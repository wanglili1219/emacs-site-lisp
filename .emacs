;;load path
;;====================    
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (defconst my-site-lisp-path "C:/emacs-24.3/site-lisp" "my load path")))
 ((or (string-equal system-type "darwin")   ; Mac OS X
      (string-equal) system-type "gnu/linux") ; linux
  (progn
    (defconst my-site-lisp-path "/Applications/Emacs.app/Contents/Resources/site-lisp" "my load path"))))

(add-to-list 'load-path (concat my-site-lisp-path "/auto-complete-1.3.1"))
(add-to-list 'load-path (concat my-site-lisp-path "/cedet-1.1"))
(add-to-list 'load-path (concat my-site-lisp-path "/color-theme-6.6.0"))
(add-to-list 'load-path (concat my-site-lisp-path "/doxymacs-1.8.0"))
(add-to-list 'load-path (concat my-site-lisp-path "/ecb-2.40"))
(add-to-list 'load-path (concat my-site-lisp-path "/session-2.3"))
(add-to-list 'load-path (concat my-site-lisp-path "/xcscope"))
(add-to-list 'load-path (concat my-site-lisp-path "/yasnippet-0.6.1c"))
(add-to-list 'load-path (concat my-site-lisp-path "/w3m"))
(add-to-list 'load-path (concat my-site-lisp-path "/elib"))
(add-to-list 'load-path (concat my-site-lisp-path "/jdee-2.4.1/lisp"))

;;====================
(require 'artist)

;;====================
(load "graphviz-dot-mode") 

;;====================
(require 'file-search)

;;====================
(require 'yasnippet)
(require 'yasnippet-bundle)
(yas/initialize)
(yas/load-directory (concat my-site-lisp-path "/yasnippet-0.6.1c"))

;; cygwin
;;====================
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (setenv "CYGWIN" "nodosfilewarning")
    (setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))
    (setenv "PATH" (concat "d:/home/work/tools/;c:/Qt/4.8.5/qmake;" (getenv "PATH")))
    (setenv "QMAKESPEC" "c:/Qt/4.8.5/mkspecs/win32-g++-4.6/")
    (setq explicit-shell-file-name "bash.exe")
    (setq exec-path (cons "c:/cygwin/bin/" exec-path))))
 ((or (string-equal system-type "darwin")   ; Mac OS X
      (string-equal) system-type "gnu/linux") ; linux
  (progn
    (setenv "PATH" (concat "/Applications/Emacs.app/Contents/MacOS/bin:/usr/local/bin:/sbin:" (getenv "PATH")))
    (setq explicit-shell-file-name "bash"))))

(require 'cygwin-mount)
(cygwin-mount-activate)

(add-hook 'comint-output-filter-functions
    'shell-strip-ctrl-m nil t)

(add-hook 'comint-output-filter-functions
    'comint-watch-for-password-prompt nil t)

;; For subprocesses invoked via the shell
;; (e.g., "shell -c command")
(setq shell-file-name explicit-shell-file-name)
(require 'shell)

(defun shell-symbian ()
  "10Jan02, sailor. Invoke a bash shell for Symbian"
  (interactive)
  (let ((bufname "*shell-symbian*")
        (bufobject))

    (setq bufobject (get-buffer bufname))

    (cond
     ((and bufobject (get-buffer-process bufobject))
      (pop-to-buffer bufname)
      )
     (t
      (progn
        (set-buffer
           (apply 'make-comint-in-buffer
                  "shell"
                  bufname
                  explicit-shell-file-name
                  nil
                  '("--rcfile" "c:/documents/config/.symbianrc" "-i")
                  ))
        (shell-mode)
        (pop-to-buffer (current-buffer))
        )
      )
     )
    )
  )

;;Some people like to use the up and down arrow keys to traverse through the previous commands. Here is the way to bind the keys.
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "12Jan2002 - sailor, shell mode customizations."
  (local-set-key '[up] 'comint-previous-input)
  (local-set-key '[down] 'comint-next-input)
  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
  )

;;When the "clear" command is entered into the bash shell, it is expected to clear the entire shell buffer. However, this does not work for bash shell under Gnu Emacs. The following lisp statements solve the problem.

;;Notice that the following statements also intercepts the "man" command entered by the user and execute it outside the shell.
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "12Jan2002 - sailor, shell mode customizations."
  (local-set-key '[up] 'comint-previous-input)
  (local-set-key '[down] 'comint-next-input)
  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
  (setq comint-input-sender 'n-shell-simple-send)
  )

(defun n-shell-simple-send (proc command)
  "17Jan02 - sailor. Various commands pre-processing before sending to shell."
  (cond
   ;; Checking for clear command and execute it.
   ((string-match "^[ \t]*clear[ \t]*$" command)
    (comint-send-string proc "\n")
    (erase-buffer)
    )
   ;; Checking for man command and execute it.
   ((string-match "^[ \t]*man[ \t]*" command)
    (comint-send-string proc "\n")
    (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
    (setq command (replace-regexp-in-string "[ \t]+$" "" command))
    ;;(message (format "command %s command" command))
    (funcall 'man command)
    )
   ;; Send other commands to the default handler.
   (t (comint-simple-send proc command))
   )
  )

;;====================
(require 'ntcmd)

;;====================
(require 'session) 
(add-hook 'after-init-hook 'session-initialize) 
(load "desktop") 
(desktop-save-mode) 

;;====================
(require 'doxymacs)
(require 'xml-parse)
(add-hook 'c-mode-common-hook 'doxymacs-mode)

;;====================
(require 'ecb-autoloads)
(setq stack-trace-on-error t)
(setq ecb-activate t)
(setq ecb-auto-activate t
      ecb-tip-of-the-day nil)
      
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

(setq gdb-many-windows t)
(load-library "multi-gud.el")
(load-library "multi-gdb-ui.el")


;;xscope
;;====================
(require 'xcscope)
(setq cscope:menu t)
(setq cscope-do-not-update-database t)

;;====================
(require 'cedet)
(require 'semantic)
(require 'ede)
(require 'cedet-cscope)

(global-ede-mode t)
(setq semanticdb-default-save-directory 
(expand-file-name "~/.emacs.d/semanticdb")) 
(require 'semantic-c nil 'noerror)

(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))

(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)

;;BOOKMARK
;;====================
(enable-visual-studio-bookmarks)
(require 'eassist nil 'noerror)
(define-key c-mode-base-map [M-f8] 'eassist-switch-h-cpp)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))


;;====================
(tool-bar-mode nil)

;;====================
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)
 
;;====================
(ido-mode t)
(setq visible-bell t)
(setq inhibit-startup-message t)
(setq gnus-inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)

(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not  text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))

(setq column-number-mode t) 
(setq line-number-mode t)
(setq mouse-yank-at-point t)
(setq kill-ring-max 200)

(setq-default indent-tabs-mode nil)

(setq default-tab-width 4)

(setq sentence-end "\\([隆拢拢隆拢驴]\\|隆颅隆颅\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")

(setq sentence-end-double-space nil)

(setq enable-recursive-minibuffers t)

(setq scroll-margin 3  scroll-conservatively 10000)

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill) 

(setq show-paren-style 'parenthesis)

(setq mouse-avoidance-mode 'animate)

(setq frame-title-format "emacs@%b")

(setq uniquify-buffer-name-style 'forward)

(setq auto-image-file-mode t)

(setq global-font-lock-mode t)

(setq-default kill-whole-line t)

(add-hook 'comint-output-filter-functions
      'comint-watch-for-password-prompt)

(setq auto-save-mode nil) 

(setq-default make-backup-files nil)

(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil) 
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

(setq x-select-enable-clipboard t)

(setq mouse-yank-at-point t)

(setq user-mail-address "wanglili@mo-star.com")

(setq require-final-newline t)

(setq-default transient-mark-mode t)

(setq track-eol t)

(setq Man-notify-method 'pushy)

(setq next-line-add-newlines nil)
  
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)

(global-set-key (kbd "C-,") 'scroll-left)
(global-set-key (kbd "C-.") 'scroll-right)

(global-set-key [f1] 'manual-entry)
(global-set-key [C-f1] 'info )

(global-set-key [f3] 'repeat-complex-command)

(global-set-key [f4] 'other-window)

(defun du-onekey-compile ()
  "Save buffers and start compile"
  (interactive)
  (save-some-buffers t)
  (switch-to-buffer-other-window "*compilation*")
  (compile compile-command))
  (global-set-key [C-f5] 'compile)
  (global-set-key [f5] 'du-onekey-compile)

(global-set-key [f6] 'gdb)             

(global-set-key [C-f7] 'previous-error)
(global-set-key [f7] 'next-error)

(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))
(global-set-key [(f8)] 'open-eshell-other-buffer)
(global-set-key [C-f8] 'eshell)

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
(global-set-key [C-f9] 'dired)

(global-set-key [f10] 'undo)             

(global-set-key [C-f11] 'calendar) 

(global-set-key [C-f12] 'list-bookmarks)

(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:y-%02m-%02d %3a %02H:%02M:%02S chunyu")

(global-set-key (kbd "M-g") 'goto-line)

(global-set-key (kbd "C-SPC") 'nil)

(global-set-key (kbd "M-<SPC>") 'set-mark-command)

(add-to-list 'Info-default-directory-list  "/Applications/Emacs.app/Contents/Resources/info")

(setq compile-command "make")

(add-hook 'c-mode-hook
'(lambda ()
(c-set-style "k&r")))

(add-hook 'c++-mode-hook
'(lambda()
(c-set-style "stroustrup")))

;;====================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cscope-program "c:/cscope-15.7/cscope.exe")
 '(ecb-options-version "2.40")
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "zh-CN")
 '(google-translate-enable-ido-completion t)
 '(google-translate-show-phonetic nil)
 '(jde-global-classpath (quote ("/Users/renren/work/renren/server/newslot/www/WEB-INF/lib" "/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/lib" "/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/jre/lib" "/System/Library/Java/Support/CoreDeploy.bundle/Contents/Resources/Java" "System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes")))
 '(jde-jdk (quote ("1.7")))
 '(jde-jdk-registry (quote (("1.7" . "/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home") ("1.6" . "/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"))))
 '(jde-sourcepath (quote ("." "/Users/renren/work/renren/server/newslot/www/WEB-INF/lib/*.jar" "/Users/renren/work/renren/server/newslot" "/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes" "")))
 '(lf-lua-find-project-root-path "/Users/renren/work/renren/client/SlotsQueen_Single/LuaScript/")
 '(mk-proj-use-ido-selection t)
 '(session-use-package t nil (session))
 '(speedbar-show-unknown-files t)
 '(sr-speedbar-max-width 50)
 '(sr-speedbar-right-side nil)
 '(sr-speedbar-skip-other-window-p t)
 '(sr-speedbar-width-x 30)
 '(tags-table-list (quote ("d:/home/work/cocos2dx/cocos2d-1.0.1-x-0.12.0-qt/TAGS")))
 '(tooltip-hide-delay 120)
 '(w3m-command "C:/w3m-0.5.1-2/usr/bin/w3m.exe"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; shell-mode
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t) 
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t) 

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq-default ac-sources '(ac-source-words-in-same-mode-buffers))
(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")
(define-key ac-completing-map "\M-n" 'ac-next)
(define-key ac-completing-map "\M-p" 'ac-previous)
(setq ac-auto-start 2)
(setq ac-dwim t)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

;;2013-9-27
(add-to-list 'ac-modes 'objc-mode)

;; pymacs
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")

;;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-startup-indented t)

;; linum
(require 'linum)
(global-linum-mode 1)

(tool-bar-mode -1)

(setq default-buffer-file-coding-system 'utf-8-unix)            
(setq default-file-name-coding-system 'utf-8-unix)              
(setq default-keyboard-coding-system 'utf-8-unix)               
(setq default-process-coding-system '(utf-8-unix . utf-8-unix)) 
(setq default-sendmail-coding-system 'utf-8-unix)               
(setq default-terminal-coding-system 'utf-8-unix)               

;; sr-speedbar
(require 'sr-speedbar)
(require 'speedbar-extension)
(global-set-key [f9] 'sr-speedbar-toggle)
(global-set-key (kbd "C-c b b") 'sr-speedbar-select-window)

;;
(show-paren-mode 1)
(global-unset-key "\C-xf")

;;2013-2-16
(setq w32-get-true-file-attributes nil)
;;2013-3-19
(global-set-key (kbd "C-;") 'yas/expand)

;;2013-3-20
(require 'bm)
(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)
(global-set-key (kbd "\C-cbs") 'bm-show-all)
(global-set-key (kbd "\C-cbr") 'bm-remove-all-all-buffers)

;;anything
(require 'anything-match-plugin)
(require 'anything-config)

;;2013-2-27
(require 'bookmark) 
(when (not (file-exists-p bookmark-default-file)) 
   (bookmark-save)) 
(bookmark-load bookmark-default-file t t) 
  
(defvar *leisureread-my-book-path* "~/misc/book.txt") 
(defvar *leisureread-bookmark-name* "leisureread") 
(defvar *leisureread-window-height* 1) 
  
(defun leisureread-initialize-bookmark-if-necessary () 
   ;; if no previous bookmark, create it at first line 
   (when (or (null bookmark-alist) 
             (null (assoc *leisureread-bookmark-name* bookmark-alist))) 
     (find-file *leisureread-my-book-path*) 
     (bookmark-set *leisureread-bookmark-name*) 
     (bury-buffer)) 
   ;; if not opened book.txt yet, open it and keep it open 
   (when (not (get-file-buffer *leisureread-my-book-path*)) 
     (save-excursion 
       (find-file *leisureread-my-book-path*) 
       (bookmark-jump *leisureread-bookmark-name*) 
       (bury-buffer)))) 
  
(defun leisureread-line-prefix () 
   (concat comment-start "+")) 
  
(defun leisureread-decorate-lines (text) 
   (let ((lines (split-string text "\n"))) 
     (let ((decorated-lines 
            (mapcar (lambda (line) (concat (leisureread-line-prefix) line)) 
                    lines))) 
       (reduce (lambda (acc next) (concat acc "\n" next)) 
               decorated-lines)))) 
  
  
(defun leisureread-on-leisure-line-p () 
   (let ((text (buffer-substring-no-properties 
                   (line-beginning-position) 
                   (line-end-position)))) 
     (start-with-p text (leisureread-line-prefix)))) 
  
(defun start-with-p (big small) 
   (and (>= (length big) (length small)) 
        (string= small (substring big 0 (length small))))) 
           
(defun leisureread-clear-line () 
   (interactive) 
   (while (leisureread-on-leisure-line-p) 
     (kill-whole-line))) 
  
(defun leisureread-insert-next-line () 
   (interactive) 
   (leisureread-insert-line 'forward-line)) 
  
(defun leisureread-insert-previous-line () 
   (interactive) 
   (leisureread-insert-line 'previous-line)) 
  
(defun leisureread-insert-line (func) 
   (leisureread-initialize-bookmark-if-necessary) 
   (move-beginning-of-line nil) 
   (let ((text "")) 
     (while (<= (length text) 1) 
       (save-excursion 
         (set-buffer (get-file-buffer *leisureread-my-book-path*)) 
         (funcall func) 
         (setq text (buffer-substring-no-properties 
                     (line-beginning-position) 
                     (line-end-position *leisureread-window-height*))) 
         (bookmark-set *leisureread-bookmark-name*) 
         (bury-buffer))) 
     (save-excursion 
       (leisureread-clear-line) 
       (insert (leisureread-decorate-lines text)) 
       (newline)))) 
  
  
(global-set-key (kbd "C-.") 'leisureread-insert-next-line) 
(global-set-key (kbd "C-,") 'leisureread-insert-previous-line) 
(global-set-key (kbd "C-'") 'leisureread-clear-line) 

;;show buffer path/name on title.
(setq frame-title-format 
       '((:eval (funcall (lambda () (if buffer-file-name 
                                        buffer-file-name 
                                      (buffer-name))))))) 


(set-default-font "Courier New-13")

;;2013-9-27
(setq auto-mode-alist
      (cons '("\\.mm$" . objc-mode) auto-mode-alist))

;;2013-10-20
(setq todo-file-do "~/todo/do")
(setq todo-file-done "~/todo/done")
(setq todo-file-top "~/todo/top")

;;2013-11-6
(require 'lua-block)
(lua-block-mode t)
(setq lua-block-highlight-toggle t)

(add-hook 'lua-mode-hook 'hs-minor-mode)

(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-search "w3m-search" "Search words using emacs-w3m." t)

(setq browse-url-browser-function 'w3m-browse-url)

(setq w3m-use-toolbar t)

(setq w3m-use-cookies t)

(setq w3m-use-tab-menubar t)

(setq w3m-command-arguments '("-cookie" "-F"))

(setq w3m-tab-width 8)

(setq w3m-home-page "http://www.google.com")
(setq w3m-view-this-url-new-session-in-background t)
(add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)

(defun remove-w3m-output-garbages ()
  " 楼碌么w3m 盲鲁枚碌  卢禄酶."
  (interactive)
  (let ((buffer-read-only))

    (setf (point) (point-min))
    (while (re-search-forward "[\200-\240]" nil t)
      (replace-match " "))
    (set-buffer-multibyte t))
  (set-buffer-modified-p nil))

(when (boundp 'utf-translate-cjk)
  (setq utf-translate-cjk t)
  (custom-set-variables
   '(utf-translate-cjk t)))
(if (fboundp 'utf-translate-cjk-mode)
    (utf-translate-cjk-mode 1))

;;====================
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)
;;(setq sdcv-program-path "/opt/local/bin/sdcv")
(setq sdcv-program-path "C:/StarDict/stardict.exe")
(require 'emacs-rc-sdcv)

;; the font for Chinese ;
(set-language-environment 'Chinese-GB )

;;;php
(require 'php-mode)

;;; dired
(add-hook 'dired-mode-hook
 (lambda ()
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ; was dired-up-directory
 ))
(put 'dired-find-alternate-file 'disabled nil)

(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;====================
(defun lua-find-mode-hook ()
  ""
  (require 'lua-find)
  (local-set-key (kbd "\C-cls") 'find-lua-string-at-point)
  (local-set-key (kbd "\C-cld") 'find-lua-function-define-at-point)
  (local-set-key (kbd "\C-clf") 'lua-show-file-function)
  (local-set-key (kbd "\C-clgv") 'lua-generate-visitor-function))

(add-hook 'lua-mode-hook 'lua-find-mode-hook)

;;====================
;; (require 'replace-buffer)
;; (global-set-key (kbd "\C-cbp") 'replace-buffer-with-path-prefix)
;; (global-set-key (kbd "\C-cbu") 'show-using-path-prefix)

;;====================
(require 'mk-project)
(global-set-key (kbd "C-c p c") 'project-compile)
(global-set-key (kbd "C-c p l") 'project-load)
(global-set-key (kbd "C-c p a") 'project-ack)
(global-set-key (kbd "C-c p g") 'project-grep)
(global-set-key (kbd "C-c p o") 'project-multi-occur)
(global-set-key (kbd "C-c p u") 'project-unload)
(global-set-key (kbd "C-c p f") 'project-find-file) ; or project-find-file-ido
(global-set-key (kbd "C-c p i") 'project-index)
(global-set-key (kbd "C-c p s") 'project-status)
(global-set-key (kbd "C-c p h") 'project-home)
(global-set-key (kbd "C-c p d") 'project-dired)
(global-set-key (kbd "C-c p t") 'project-tags)

(project-def "SlotsQueen"
      '((basedir          "/Users/renren/work/renren/client/SlotsQueen/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "LuaIMSlots.cpp" "*.o" "*.pkg" "*cscope*" "LuaRenrenGamesKit.cpp"))
        (ignore-directorys ("*proj.ios*" "*CCB*"))
        (search-directorys ("*Classes*" "*LuaScript*"))
        (tags-file        "~/mk-project/SlotsQueen/TAGS")
        (file-list-cache  "~/mk-project/SlotsQueen/FILES")
        (open-files-cache "~/mk-project/SlotsQueen/OPEN-FILES")
        (vcs              svn)
        (compile-cmd      "ant@")
        (ack-args         "--lua")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "SlotsQueen_Single"
      '((basedir          "/Users/renren/work/renren/client/SlotsQueen_Single/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "LuaIMSlots.cpp" "*.o" "*.pkg" "*cscope*" "LuaRenrenGamesKit.cpp"))
        (ignore-directorys ("*proj.ios*" "*CCB*"))
        (search-directorys ("*Classes*" "*LuaScript*"))
        (tags-file        "~/mk-project/SlotsQueen_Single/TAGS")
        (file-list-cache  "~/mk-project/SlotsQueen_Single/FILES")
        (open-files-cache "~/mk-project/SlotsQueen_Single/OPEN-FILES")
        (vcs              svn)
        (compile-cmd      "ant")
        (ack-args         "--lua")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "Cocos2dx"
      '((basedir          "/Users/renren/work/cocos2d-x-2.2/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "*.o" "*.pkg" "*cscope*"))
        ;;(ignore-directorys ())
        ;;(search-directorys ())
        (tags-file        "~/mk-project/Cocos2dx/TAGS")
        (file-list-cache  "~/mk-project/Cocos2dx/FILES")
        (open-files-cache "~/mk-project/Cocos2dx/OPEN-FILES")
        (vcs              svn)
        (compile-cmd      "gcc")
        (ack-args         "--cpp")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "CoolBox"
      '((basedir          "/Users/renren/work/opengl/CoolBox/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "*.o" "*.pkg" "*cscope*"))
        (ignore-directorys ("*CoolBox.xcodeproj*" "*git*"))
        ;;(search-directorys ())
        (tags-file        "~/mk-project/CoolBox/TAGS")
        (file-list-cache  "~/mk-project/CoolBox/FILES")
        (open-files-cache "~/mk-project/CoolBox/OPEN-FILES")
        (vcs              svn)
        (compile-cmd      "gcc")
        (ack-args         "--cpp")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "TestQT"
      '((basedir          "/Users/renren/work/QT/Qt5.2.1/5.2.1/clang_64/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "*.o" "*.pkg" "*cscope*"))
        ;;(ignore-directorys ("*CoolBox.xcodeproj*" "*git*")) 
        ;;(search-directorys ())
        (tags-file        "~/mk-project/TestQT/TAGS")
        (file-list-cache  "~/mk-project/TestQT/FILES")
        (open-files-cache "~/mk-project/TestQT/OPEN-FILES")
        (vcs              svn)
        (compile-cmd      "gcc")
        (ack-args         "--cpp")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "C2DQT"
      '((basedir          "~/work/cocos2dx/cocos2d-1.0.1-x-0.12.0-qt/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("git" "*.out" "#*#" "*.o" "*.pkg" "*cscope*" "*obj*" "*vcxproj*"))
        (ignore-directorys ("*git*")) 
        ;;(search-directorys ())
        (tags-file        "~/mk-project/c2dqt/TAGS")
        (file-list-cache  "~/mk-project/c2dqt/FILES")
        (open-files-cache "~/mk-project/c2dqt/OPEN-FILES")
        (vcs              git)
        (compile-cmd      "gcc")
        (ack-args         "--cpp")
        (startup-hook     nil)
        (shutdown-hook    nil)))

(project-def "TILED"
      '((basedir          "~/work/tiled/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("git" "*.out" "#*#" "*.o" "*.pkg" "*cscope*" "*obj*" "*vcxproj*"))
        (ignore-directorys ("*git*")) 
        ;;(search-directorys ())
        (tags-file        "~/mk-project/Tiled/TAGS")
        (file-list-cache  "~/mk-project/Tiled/FILES")
        (open-files-cache "~/mk-project/Tiled/OPEN-FILES")
        (vcs              git)
        (compile-cmd      "gcc")
        (ack-args         "--cpp")
        (startup-hook     nil)
        (shutdown-hook    nil)))


;;====================
(require 'xfrp_find_replace_pairs)

;;====================
(require 'google-translate)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)

;;====================
(defun my-revert-all-buffer-file-be-edited()
  (interactive)
  (let ((revert-count 0))
    (mapcar (lambda (buf)
              (setq buffile (buffer-file-name buf))
              (if (and (stringp buffile) 
                       (file-exists-p buffile))
                  (progn
                    (if (not (verify-visited-file-modtime buf))
                        (progn (message (format "File: %s be edited, revert it!\n" buffile))
                               (set-buffer buf)
                               (revert-buffer nil t)
                               (setq revert-count (+ 1 revert-count)))))))
            (buffer-list))
    (message (format "Check Buffer Done! Revert buffer: %d\n" revert-count))))

(global-set-key (kbd "C-c r b") 'my-revert-all-buffer-file-be-edited) 

;;====================
(global-set-key (kbd "C-c v") (kbd "C-u 120 C-x 3"))

;;====================
(require 'dired+)

;;====================
(require 'ediff-trees)
(global-set-key (kbd "M-N") 'ediff-trees-examine-next)
(global-set-key (kbd "M-P") 'ediff-trees-examine-previous)
(global-set-key (kbd "C-s-SPC") 'ediff-trees-examine-next-regexp)
(global-set-key (kbd "C-S-s-SPC") 'ediff-trees-examine-previous-regexp)

;;====================
(defvar anything-cpp-show-file-function
  '((name . "C/CPP Function")
    (headline "[ _a-zA-Z]*\(.*\)")))


(defun cpp-show-file-function ()
  (interactive)
  (let ((anything-candidate-number-limit 500))
    (anything-other-buffer '(anything-cpp-show-file-function)
                           "*C/CPP Function*")))

(defun cpp-show-function-hook ()
  ""
  (local-set-key (kbd "\C-ccf") 'cpp-show-file-function))

(add-hook 'c++-mode-hook 'cpp-show-function-hook)
(add-hook 'c-mode-hook 'cpp-show-function-hook)

(defun dired-open-path-with-explorer()
  (interactive)
  (let ((dirstr "")
        (cmdstr ""))
    (setq dirstr (dired-get-filename))
    (if (> (length dirstr) 0)
        (progn
          (setq dirstr (file-name-directory dirstr))
          (setq dirstr (replace-regexp-in-string "/" "\\\\" dirstr))))
    (setq cmdstr (format "explorer /e,\'%s\'" dirstr))
    (shell-command cmdstr)))

(defun dired-open-path-with-explorer-hook()
  ""
  (local-set-key (kbd "\C-co") 'dired-open-path-with-explorer))

(defun adjuest-path-to-windows-nt-path (pathstr)
  (if (string-match-p "^~/" pathstr)
      (setq pathstr (file-truename pathstr)))

  (if (string-match-p "^/cygdrive" pathstr)
      (let (cygstr drivername remainpath newstr)
        (setq drivername (substring pathstr 10 11))
        (message drivername)
        (setq cygstr (substring pathstr 0 11))
        (setq remainpath (substring pathstr 11 (length pathstr)))
        (setq newstr (concat drivername ":" remainpath))
        newstr)
      pathstr))

(defun open-director-at-cursor-with-explorer()
  ""
  (interactive)
  (let ((dirstr)
        (path (if (region-active-p)
                 (buffer-substring-no-properties (region-beginning) (region-end))
                (thing-at-point 'filename))))

  (setq dirstr (adjuest-path-to-windows-nt-path path))
  (if (> (length dirstr) 0)
      (progn
        (if (not (file-directory-p dirstr))
            (setq dirstr (file-name-directory dirstr)))
        (setq dirstr (replace-regexp-in-string "/" "\\\\" dirstr))))
  (setq cmdstr (format "explorer /e,\'%s\'" dirstr))
  (shell-command cmdstr)))

(defun open-director-at-buffer-with-explorer ()
  (interactive)
  (let (dirstr)
    (setq dirstr (buffer-file-name (current-buffer)))
    (if (> (length dirstr) 0)
        (progn
          (setq dirstr (file-name-directory dirstr))
          (setq dirstr (replace-regexp-in-string "/" "\\\\" dirstr))
          (setq cmdstr (format "explorer /e,\'%s\'" dirstr))
          (shell-command cmdstr)))))

(cond
 ((string-equal system-type "windows-nt")
  (global-set-key (kbd "C-c f o") 'open-director-at-cursor-with-explorer)
  (global-set-key (kbd "C-c b o") 'open-director-at-buffer-with-explorer)
  (add-hook 'dired-mode-hook 'dired-open-path-with-explorer-hook)))

;;====================
(defun replace-path-split-char-region-un (start end)
  "Replace “\” to “/”."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "[\\]+" nil t) (replace-match "/" nil t))))

(defun replace-path-split-char-region-win (start end)
  "Replace “/” to “\”."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (search-forward "/" nil t) (replace-match "\\" nil t))
    ))

(global-set-key (kbd "C-c f u") 'replace-path-split-char-region-un)
(global-set-key (kbd "C-c f w") 'replace-path-split-char-region-win)
