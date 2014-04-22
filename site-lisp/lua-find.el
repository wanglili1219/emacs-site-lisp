(require 'anything-match-plugin)
(require 'anything-config)

(defconst find-result-buffer-name "*LuaFind*")

(defgroup luafind nil
  ""
  :prefix "lf-")

(defcustom lf-lua-find-project-root-path "/Users/renren/work/renren/client/SlotsQueen_Single/LuaScript"
  "*The path of project for find"
  :type 'string
  :group 'luafind)

(defface lua-file-face
  '((((class color) (background dark))
     (:foreground "yellow"))
    (((class color) (background light))
     (:foreground "blue"))
    (t (:bold t)))
  ""
  :group 'luafind)

(defface lua-line-number-face
  '((((class color) (background dark))
     (:foreground "red"))
    (((class color) (background light))
     (:foreground "red"))
    (t (:bold t)))
  ""
  :group 'luafind)

(defface lua-line-match-face
  '((((class color) (background dark))
     (:foreground "cyan"))
    (((class color) (background light))
     (:foreground "magenta"))
    (t (:bold t)))
  ""
  :group 'luafind)

(defvar find-lua-buffer-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'lua-open-file-and-goto-line)
    (define-key map (kbd "q") 'lua-quit-window)
    map)
  "")

(defvar anything-lua-show-file-function
  '((name . "Lua Function")
    (headline  ".*function +.+\(.*\)")))

(defun lua-quit-window nil
  ""
  (interactive)
  (quit-window nil (get-buffer-window find-result-buffer-name)))

(defun lua-open-file-and-goto-line nil
  (interactive)
  (setq linenum (get-text-property (point) 'linenumber))
  (setq filepath (get-text-property (point) 'filepath))
  (setq line (get-text-property (point) 'linestring))
  (set-text-properties 0 (length line)  nil line)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward line (point-max) t)
        (replace-match line)
      ))
  (setq filebuf (find-file-noselect filepath))
  (pop-to-buffer filebuf)
  (beginning-of-buffer)
  (forward-line (- (string-to-number linenum) 1)))

(defun extract-line-number(str)
  (string-match ":\\([^:]+\\):" str)
  (setq linenum (match-string 1 str))
  linenum)

(defun extract-file-path(str)
  (string-match "\\([^:]+\\):" str)
  (setq filepath (match-string 1 str))
  filepath)

(defun find-lua-string-by-shell(shellcmd)
  (let* ((findstr (shell-command-to-string shellcmd))
         (lines-list (split-string findstr "\n" t))
         linenumcolorbeg)
    (with-output-to-temp-buffer find-result-buffer-name 
      (set-buffer standard-output)
      (mapcar
       (lambda (line)
         (setq linenum (extract-line-number line))
         (setq filepath (extract-file-path line))
         (put-text-property 0 (length filepath) 'face 'lua-file-face line)
         (setq linenumcolorbeg (+ (length filepath) 1))
         (put-text-property linenumcolorbeg (+ linenumcolorbeg (length linenum)) 'face 'lua-line-number-face line)
         (put-text-property (+ linenumcolorbeg (length linenum)) (length line) 'face 'lua-line-match-face line)
         (put-text-property 0 (length line) 'linenumber linenum line)
         (put-text-property 0 (length line) 'filepath filepath line)
         (put-text-property 0 (length line) 'linestring line line)
         (insert line)
         (insert "\n\n"))
       lines-list)

      (kill-all-local-variables)
      (use-local-map find-lua-buffer-map)
      (pop-to-buffer (current-buffer)))))

(defun string-at-point nil
  (interactive)
  (let (from to bound sym)
    (setq sym
          (when (or (progn
                      ;; Look at text around `point'.
                      (save-excursion
                        (skip-chars-backward "_a-zA-Z0-9") (setq from (point)))
                      (save-excursion
                        (skip-chars-forward "_a-zA-Z0-9") (setq to (point)))
                      (> to from))
                    ;; Look between `line-beginning-position' and `point'.
                    (save-excursion
                      (and (setq bound (line-beginning-position))
                           (skip-chars-backward "_a-zA-Z0-9" bound)
                           (> (setq to (point)) bound)
                           (skip-chars-backward "_a-zA-Z0-9")
                           (setq from (point))))
                    ;; Look between `point' and `line-end-position'.
                    (save-excursion
                      (and (setq bound (line-end-position))
                           (skip-chars-forward "_a-zA-Z0-9" bound)
                           (< (setq from (point)) bound)
                           (skip-chars-forward "_a-zA-Z0-9")
                           (setq to (point)))))
            (buffer-substring-no-properties from to)))
    sym))

(defun find-lua-string-at-point nil
  (interactive)
  (setq sym (string-at-point))
  (setq usersym (read-string "Find Lua String:" sym))
  (if (and (stringp usersym) (> (length usersym) 0))
      (progn
        (setq shellcmd (concat "find -E " lf-lua-find-project-root-path " -regex '.*\.(lua|LUA)$' | xargs egrep -n " usersym))
        (find-lua-string-by-shell shellcmd))))

(defun find-lua-function-define-at-point nil
  (interactive)
  (setq sym (string-at-point))
  (setq usersym (read-string "Find lua function define:" sym))
  (if (and (stringp usersym) (> (length usersym) 0))
      (progn
        (setq shellcmd (concat "find " lf-lua-find-project-root-path " -name '*.lua' | xargs egrep -n " "\".*function([[:space:]]+|[[:space:]]+.+[:\.])" usersym "[[:space:]]*\\([[:space:]]*.*[[:alpha:]]*.*[[:space:]]*\\)\""))
        (find-lua-string-by-shell shellcmd))))

(defun lua-show-file-function ()
  (interactive)
  ;; Set to 500 so it is displayed even if all methods are not narrowed down.
  (let ((anything-candidate-number-limit 500))
    (anything-other-buffer '(anything-lua-show-file-function)
                           "*Lua Function*")))

(defun lua-s-trim-left (s)
  "Remove whitespace at the beginning of S."
  (if (string-match "[ \t\n\r]+" s)
      (replace-match "" t t s)
    s))

(defun lua-s-trim-right (s)
  "Remove whitespace at the end of S."
  (if (string-match "[ \t\n\r]+$" s)
      (replace-match "" t t s)
    s))

(defun lua-s-trim (s)
  "Remove whitespace at the beginning and end of S."
  (s-trim-left (s-trim-right s)))

(defun lua-generate-visitor-function (beg end)
  (interactive "r")
  (if (region-active-p)
      (let (blockstr tablename memberstr form to membername (memberslist '()))
        (setq blockstr (buffer-substring beg end))
        (with-temp-buffer
          (insert blockstr)
          (goto-char (point-min))
          (skip-chars-forward " \t\n\r")
          (setq from (point))
          (save-excursion
            (skip-syntax-forward "w")
            (setq bound (point))
            (skip-syntax-backward "w")
            (if (search-forward "local" bound t 1)
                (setq from bound)))

          (goto-char from)
          (skip-chars-forward "[:space:]_a-zA-Z0-9")
          (setq to (point))
          (setq tablename (lua-s-trim (buffer-substring from to)))
          (message "tablename %s" tablename)
          (save-excursion
            (setq endpoint (search-forward "}" (point-max) t 1)))
          (while (re-search-forward "[^\{\},]+" endpoint t)
            (setq membername (lua-s-trim (car (split-string (match-string 0) "="))))
            (string-match "[[:space:]\t\n\r]*" membername)
            (setq membername (replace-match "" nil nil membername 0))
            (if  (= (length membername) 0)
                (message "nil member")
              (setq memberslist (append memberslist (list membername))))
              )
          (with-output-to-temp-buffer "Visitor List"
            (set-buffer standard-output)
            (insert (concat tablename ".__index = " tablename "\n\n"))
            (insert (concat "function " tablename ":new ()" "\n"))
            (insert "    local o = {}" "\n")
            (insert "    setmetatable(o, self)" "\n")
            (insert "    return o" "\n")
            (insert "end" "\n\n")
            (mapcar (lambda (name)
                      (setq funname (upcase-initials name))
                      (insert (concat "function " tablename ":get" funname "()" "\n"))
                      (insert (concat "    return " name "\n"))
                      (insert (concat "end" "\n\n"))
                      (insert (concat "function " tablename ":set" funname "(value)" "\n"))
                      (insert (concat "    " name " = value" "\n"))
                      (insert (concat "end" "\n\n")))
                    memberslist))
            (pop-to-buffer (current-buffer))
          ))))

;;lua-find ends here
(provide 'lua-find)

