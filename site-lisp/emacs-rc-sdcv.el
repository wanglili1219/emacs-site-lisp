;;; emacs-rc-sdcv.el ---

;; Copyright (C) Alex Ott
;;
;; Author: Alex Ott <alexott@gmail.com>
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet

;; (require 'sdcv-mode)
;; (global-set-key (kbd "C-c s") 'sdcv-search)

(defun kid-star-dict ()
  (interactive)
  (let (searchword
        (begin (point-min))
        (end (point-max)))
    (if mark-active
        (setq begin (region-beginning)
              end (region-end))
      (save-excursion
        (backward-word)
        (mark-word)
        (setq begin (region-beginning)
              end (region-end))))
    (message "searching for %s ..." (buffer-substring begin end))
    (setq searchword (buffer-substring begin end))
    ;; (tooltip-show (shell-command-to-string
    ;;                (concat "/opt/local/bin/sdcv -n --utf8-output --utf8-input "
    ;;                        (buffer-substring begin end))))
 
    (with-output-to-temp-buffer "*SDCV*"
      (set-buffer standard-output)
      (let (dict-sp sdcv-string sdcv-field mean-list sample-list one-exp star-list)
        (setq sdcv-string (shell-command-to-string
                           (concat "/usr/bin/sdcv " " -n --utf8-output --utf8-input " searchword)))
        (setq dict-sp (string-match "-->\u725b\u6d25\u73b0\u4ee3\u82f1\u6c49\u53cc\u89e3\u8bcd\u5178" sdcv-string))
        (insert (substring sdcv-string 0 dict-sp))
        (setq sdcv-string (substring sdcv-string dict-sp))
        (setq sdcv-field (split-string sdcv-string "\n"))
        (mapcar (lambda (one-field)
                  (if (not (and (> (length one-field) 0)
                                (string-match "^/.+/" one-field)))
                      (insert one-field)
                    (setq mean-list (split-string one-field "[[:digit:]]"))
                    (mapcar (lambda (one-mean)
                              (setq sample-list (split-string one-mean "\([b-z]\)"))
                              (mapcar (lambda (one-sample)
                                        (if (string-match "[\u4e00-\u9fa5]+.+" one-sample)
                                            (progn
                                              (setq star-list (split-string (match-string 0 one-sample) "*"))
                                              (mapcar (lambda (one-star)
                                                        (insert "\n\t") 
                                                        (insert one-star))
                                                      star-list)
                                              )))
                                      sample-list)
                              (insert "\n\n>>>"))
                            mean-list)
                    (insert "\n--------------------\n")))
                sdcv-field)))
    ))

(global-set-key (kbd "C-c s") 'kid-star-dict)

(provide 'emacs-rc-sdcv)
