;;;; blocks-in-space.lisp

(in-package #:blocks-in-space)
(declaim (inline agetf allowed-user get-streaming-url))

(defun format-mastodon-url (url &key websocket)
  "properly formats the websocket or base url"
  (let* ((begin (if websocket "wss://" "https://"))
         (s (if (str:starts-with-p begin url)
                url
                (str:concat begin url))))
    (if (str:ends-with-p "/" s)
        (subseq s 0 (1- (length s)))
        s)))

(defun get-streaming-url (client)
  "fetches the proper streaming api url for CLIENT"
  (gethash "streaming_api" (tooter:urls (tooter:instance client))))

(defun allowed-user (account)
  "checks if ACCOUNT is in the allow-list username list"
  (let ((username (first (str:split #\@ account))))
    (member username (config :allow-list) :test #'equal)))

(defun agetf (place indicator &optional default)
  "getf but for alists"
  (or (cdr (assoc indicator place :test #'equal))
      default))

(defun main ()
  "main binary entry point"
  (handler-case
      (with-user-abort
        (load-config (uiop:command-line-arguments))
        (let* ((client (make-instance 'tooter:client
                                      :access-token (config :mastodon-token)
                                      :base (format-mastodon-url (config :mastodon-url))))
               (websocket (wsd:make-client (format nil "~a/api/v1/streaming?access_token=~a&stream=~a"
                                                   (format-mastodon-url (get-streaming-url client)
                                                                        :websocket t)
                                                   (config :mastodon-token)
                                                   (config :timeline "public")))))
          (wsd:on :message websocket #'(lambda (msg)
                                         (dispatch client msg)))
          (wsd:start-connection websocket)
          (loop do (sleep 5)
                while (or (eq (wsd:ready-state websocket) :open)
                          (eq (wsd:ready-state websocket) :opening))))
    (user-abort ()))))

(defun dispatch (client message)
  (let* ((parsed (json:decode-json-from-string message))
         (status (json:decode-json-from-string (agetf parsed :payload))))
    (when (string= (agetf parsed :event) "update")
      (let ((account (agetf status :account)))
        (when (and (str:ends-with-p "@botsin.space" (agetf account :acct))
                   (not (allowed-user (agetf (agetf status :account) :acct))))
        (tooter:block client (agetf account :id)))))))
                                    
