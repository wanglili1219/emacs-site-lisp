(defgroup replace-buffer nil
  ""
  :prefix "rb-")

(defcustom rb-now-using-path-prefix "/Users/renren/work/renren/client/SlotsQueen_Single/"
  ""
  :type 'string
  :group 'replace-buffer)

(defun show-using-path-prefix nil
  (interactive)
  (message rb-now-using-path-prefix))

(defun replace-buffer-with-path-prefix nil
  (interactive)
  (let (tofile)
    (setq tofile (read-string "Replace path prefix with:" rb-now-using-path-prefix))
    (if  (or (or (null tofile) (equal (length tofile) 0))
             (string= rb-now-using-path-prefix tofile)
             (or (null rb-now-using-path-prefix) (equal (length rb-now-using-path-prefix) 0)))
        (message "Path string error.")
      (mapcar (lambda (buf)
                (setq buffile (buffer-file-name buf))
                (if (and (not (null buffile))
                         (string-match-p rb-now-using-path-prefix buffile))
                    (progn
                      (setq newbuffile (concat tofile 
                                               (substring-no-properties buffile (length rb-now-using-path-prefix))))
                      (if (file-exists-p newbuffile)
                          (progn
                            (message (format "Open file:%s\n" newbuffile))
                            (kill-buffer buf)
                            (find-file-noselect newbuffile))))))
              (buffer-list)))
    (setq rb-now-using-path-prefix tofile))
  (message "Replace All Done!"))

(provide 'replace-buffer)

