;;=================== load path ============================
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (defconst my-site-lisp-path "C:/emacs-24.3/site-lisp" "my load path")))
 ((or (string-equal system-type "darwin")   ; Mac OS X
      (string-equal) system-type "gnu/linux") ; linux
  (progn
    (defconst my-site-lisp-path "/Applications/Emacs.app/Contents/Resources/site-lisp" "my load path"))))


;;(setq load-path (cons (concat my-site-lisp-path "/xcscope") load-path))
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

;;end set path

(set-language-environment 'Chinese-GB) 
(require 'artist)

;; ============== graphviz-dot-mode ================
(load "graphviz-dot-mode") 

;;================ file search ======================
(require 'file-search)

;; ============== color theme =======================
;;(require 'color-theme)

;;   忙 芒  虏禄录 拢卢color-theme虏禄禄谩卤禄 麓  

;;(color-theme-initialize)

;;   忙 芒     卢  碌  梅 芒 隆 帽color-theme潞贸 忙   梅 芒 没

;;(color-theme-oswald)
;;(color-theme-classic)
;;(color-theme-taylor)

;;==================== python conf ==============================
;; (require 'pycomplete)
;; (require 'python-mode)

;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; (setq interpreter-mode-alist(cons '("python" . python-mode)
;;                            interpreter-mode-alist))
                           
;; (setq pdb-path '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/pdb.py
;;        gud-pdb-command-name (symbol-name pdb-path))
;;  (defadvice pdb (before gud-query-cmdline activate)
;;    "Provide a better default command line when called interactively."
;;    (interactive
;;    (list (gud-query-cmdline pdb-path
;;                  (file-name-nondirectory buffer-file-name)))))

;;==================== yasnippet conf =====================
;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp/yasnippet-0.6.1c")

;;(require 'yasnippet-bundle)   
;;(yas/initialize)   
;;(yas/load-directory "~/.emacs.d/lisp/yasnippet-read-only/snippets")  

(require 'yasnippet)
(require 'yasnippet-bundle)
(yas/initialize)
(yas/load-directory (concat my-site-lisp-path "/yasnippet-0.6.1c"))

;;==================== cygwin

;;Windows
;;(setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))
;;(setq explicit-shell-file-name "bash.exe")
;;(setq exec-path (cons "c:/cygwin/bin/" exec-path))

;;Linux/Mac
;; (setenv "PATH" (concat "/Applications/Emacs.app/Contents/MacOS/bin:/usr/local/bin:/sbin:" (getenv "PATH")))
;; (setq explicit-shell-file-name "bash")

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))
    (setenv "PATH" (concat "d:/home/work/tools/;" (getenv "PATH")))
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

;;=================== ntcmd.el
(require 'ntcmd)

;;==================== session conf =======================
;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp/session-2.3")

(require 'session) 
(add-hook 'after-init-hook 'session-initialize) 
(load "desktop") 
(desktop-save-mode) 

;;==================== doxymacs conf ======================
;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp/doxymacs-1.8.0")
(require 'doxymacs)
(require 'xml-parse)

(add-hook 'c-mode-common-hook 'doxymacs-mode)

;;==================== svn conf ===========================
(require 'vc-svn)
(require 'psvn)

;;(require 'tortoise-svn)
;;(add-to-list 'exec-path "C:/Program Files/TortoiseSVN/bin")


(add-to-list 'vc-handled-backends 'SVN)
(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)

;;=================== linum+ ==============================
;;not use
;;(require 'linum+)

;;=================== ecb conf ============================
(require 'ecb-autoloads)
(setq stack-trace-on-error t)
(setq ecb-activate t)

(setq ecb-auto-activate t
      ecb-tip-of-the-day nil)
      
      
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;; ========================= gdb-windows ==================
(setq gdb-many-windows t)

(load-library "multi-gud.el")
(load-library "multi-gdb-ui.el")


;;==================== xscope conf ====================================
;;(add-to-list 'load-path "/site-lisp/xcscope")

(load-file (concat my-site-lisp-path  "/xcscope/xcscope.el"))
(require 'xcscope)
(setq cscope:menu t)
(setq cscope-do-not-update-database t)

;;===================== cedet 猫   =====================================


;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp/cedet-1.0")

(require 'cedet)
(require 'semantic)
(require 'ede)
(require 'cedet-cscope)

;;麓貌驴陋ede project menu
 (global-ede-mode t)

(setq semanticdb-default-save-directory 
(expand-file-name "~/.emacs.d/semanticdb")) 
(require 'semantic-c nil 'noerror)

;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)
;; (global-semantic-highlight-edits-mode (if window-system 1 -1))
;; (global-semantic-show-unmatched-syntax-mode 1)
;; (global-semantic-show-parser-state-mode 1)

;; (setq semantic-idle-scheduler-idle-time 432000)
;; ;;(setq semantic-idle-scheduler-mode t)
;; ;;enable 芒赂枚mode  cedet  emacs驴   碌  卤潞貌  露炉路  枚buffer    

;; (setq imenu t)
;; ;; 芒赂枚feature驴     imenu   戮semantic路  枚鲁枚碌   拢卢潞炉 媒碌 tags

;; (setq semanticdb-minor-mode t)
;; ;;semanticdb  semantic   麓卤拢麓忙路  枚潞贸碌     碌 拢卢 霉   虏   娄赂 enable碌 隆拢

;; (setq semanticdb-load-ebrowse-caches t)
;; ;; 芒赂枚feature  虏禄  潞  路露篓拢卢麓贸赂 碌  芒 录潞  帽  semantic驴    没  ebrowse碌 陆谩鹿没

;; (setq semantic-idle-summary-mode t)
;; ;;鹿芒卤锚 拢 么   禄赂枚  /潞炉 媒碌 tag   卤拢卢禄谩  minibuffer   戮鲁枚 芒赂枚潞炉 媒 颅  

;; (setq senator-minor-mode t)
;; ;;禄谩  emacs   枚录  禄赂枚senator碌 虏 碌楼

;; ;;(setq semantic-stickyfunc-mode t)
;; ;; 芒赂枚mode禄谩赂霉戮 鹿芒卤锚 禄  掳 碌卤 掳潞炉 媒 没   戮  buffer露楼  

;; (setq semantic-decoration-mode t)
;; ;;semantic禄谩    /潞炉 媒碌 tag  路陆录  禄 玫 露 芦碌   

;; (setq semantic-idle-completions-mode t)
;; ;;鹿芒卤锚   鲁麓娄 拢 么 禄露  卤录盲潞贸拢卢semantic禄谩  露炉 谩 戮麓 麓娄驴   虏鹿 芦碌     

;; (setq semantic-highlight-func-mode t)
;; ;;semantic禄谩  禄 碌 碌  芦掳 鹿芒卤锚 霉  潞炉 媒 没赂      戮

;; (setq semantic-idle-tag-highlight-mode t)
;; ;;戮     潞炉 媒  虏驴拢卢鹿芒卤锚 拢 么   禄赂枚卤盲 驴  拢卢 没赂枚潞炉 媒  虏驴   芒赂枚卤盲 驴碌 碌 路陆露录赂     

;; (setq semantic-decoration-on-*-members t)
;; ;;掳 private潞 protected碌 潞炉 媒     芦卤锚 露鲁枚 麓

;; (setq which-func-mode t)
;; ;; 芒赂枚 盲 碌戮   emacs  麓酶碌 which-function-mode拢卢掳 鹿芒卤锚碌卤 掳 霉  碌 潞炉 媒 没   戮  mode-line

;; (setq semantic-highlight-edits-mode t)
;; ;;麓貌驴陋 芒赂枚mode潞贸拢卢emacs禄谩掳  卯陆眉  赂 鹿媒碌     赂   鲁枚 麓拢卢 莽   录  begin戮   赂  盲 毛碌 拢卢 霉    禄 碌  芦赂     

;; (setq semantic-show-unmatched-syntax-mode t)
;; ;; 芒赂枚mode禄谩掳 semantic陆芒 枚虏禄  碌       潞矛 芦  禄庐  卤锚 露鲁枚 麓拢卢卤  莽   忙 芒赂枚  录镁  麓 emacs 麓麓煤 毛   麓碌 

;; (setq semantic-show-parser-state-mode t)
;; ;;麓貌驴陋 芒赂枚mode拢卢semantic禄谩  modeline     戮鲁枚碌卤 掳陆芒 枚 麓 卢


;; 猫   路  录镁录矛 梅 路戮露
;; (defconst cedet-user-include-dirs
;;   (list ".." "../include" "../inc" "../common" "../public"
;;         "../.." "../../include" "../../inc" "../../common" "../../public"))
;; (defconst cedet-mac-include-dirs
;;   (list "/Users/liliwang/Documents/work/mstar/framework/nunu/NuNu/inc"
;;         "/Users/liliwang/Documents/work/mstar/farm/develop/trunk/api/cpp"
;;         "/Users/liliwang/Documents/work/mstar/farm/develop/trunk/client/farmstory/FarmstoryNet/src"))
        

;; (let ((include-dirs cedet-user-include-dirs))
;;   (when (eq system-type 'windows-nt)
;;     (setq include-dirs (append include-dirs cedet-mac-include-dirs)))
;;   (mapc (lambda (dir)
;;           (semantic-add-system-include dir 'c++-mode)
;;           (semantic-add-system-include dir 'c-mode))
;;         include-dirs))

;;掳贸露篓潞炉 媒 酶 陋
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

;;    戮 锚鲁 虏 碌楼
(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)

;;  猫  BOOKMARK
(enable-visual-studio-bookmarks)
(require 'eassist nil 'noerror)
;;(define-key c-mode-base-map [M-f12] 'eassist-switch-h-cpp)
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

;; Ecb碌 虏  梅:
;; C-c . g d  驴 录  卤铆麓掳驴 
;; C-c . g s  麓 毛麓掳驴 
;; C-c . g m 路陆路篓潞 卤盲 驴麓掳驴 
;; C-c . g h  煤 路麓掳驴 
;; C-c . g l  卯潞贸 隆 帽鹿媒碌 卤 录颅麓掳驴 
;; C-c . g 1 卤 录颅麓掳驴 1
;; C-c . g n 卤 录颅麓掳驴 n
;; C-c . l c  隆 帽掳忙 忙
;; C-c . l r   禄颅掳忙 忙
;; C-c . l t  漏  掳忙 忙( 酶露篓掳忙 忙)
;; C-c . l w  漏  驴 录没碌 ecb麓掳驴 
;; C-c . \    漏  卤  茂麓掳驴 

;;  盲  l 陋 隆 麓   赂(L),麓贸录 卤冒驴麓麓铆!!

;;===================== cedet 猫   end =====================================

;;=================== speedbar conf ================================

;; (require 'speedbar)
;; (setq speedbar-show-unknown-files t);;驴      戮 霉   驴 录  录掳  录镁
;; (setq dframe-update-speed nil);;虏禄  露炉 垄  拢卢  露炉 g  垄  
;; (setq speedbar-update-flag nil)
;; (setq speedbar-use-images nil);;虏禄 鹿   image 碌 路陆 陆
;; (setq speedbar-verbosity-level 0)
;; (global-set-key [f9] 'speedbar)
;;==================  speedbar conf end =============================



;;=================================================================================
;;=================================================================================

;;;;;;;;;;;;;;;;;;;; 茂  禄路戮鲁   氓 猫  陆谩 酶;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;陆芒戮枚   垄  禄矛  虏禄   媒 路fill碌    芒,潞  帽 禄 虏 麓  
;; (put-charset-property 'chinese-cns11643-5 'nospace-between-words t)
;; (put-charset-property 'chinese-cns11643-6 'nospace-between-words t)
;; (put-charset-property 'chinese-cns11643-7 'nospace-between-words t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;   猫  麓掳驴 陆莽 忙 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(set-foreground-color "grey")
;;(set-background-color "black")
;;(set-cursor-color "gold1")
;;(set-mouse-color "gold1")

(set-scroll-bar-mode nil)
;; 隆 没鹿枚露炉 赂

;;(customize-set-variable 'scroll-bar-mode 'right))
;; 猫  鹿枚露炉 赂  麓掳驴   虏 拢卢露酶 卢       贸虏 

(tool-bar-mode nil)
;; 隆 没鹿陇戮  赂

;;(setq default-frame-alist
;;              '((vertical-scroll-bars)  
;;               (top . 25)
;;               (left . 45)                               
;;               (width . 110)
;;               (height . 40)           
;;               (background-color . "black")
;;               (foreground-color . "grey")
;;               (cursor-color     . "gold1")
;;               (mouse-color      . "gold1")
;;               (tool-bar-lines . 0)
;;               (menu-bar-lines . 1)
;;               (right-fringe)
;;               (left-fringe)))

               
;;  猫   铆 芒 禄 漏   芦拢潞 茂路篓赂      戮碌 卤鲁戮掳潞  梅 芒拢卢 酶 貌 隆 帽碌 卤鲁戮掳潞  梅 芒拢卢露镁麓  隆 帽碌 卤鲁戮掳潞  隆 帽
;;(set-face-foreground 'highlight "white")
;;(set-face-background 'highlight "blue")
;;(set-face-foreground 'region "cyan")
;;(set-face-background 'region "blue")
;;(set-face-foreground 'secondary-selection "skyblue")
;;(set-face-background 'secondary-selection "darkblue")

 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;   猫  陆莽 忙陆谩 酶  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;      戮 卤录盲 猫     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(display-time-mode 1);; 么   卤录盲   戮 猫  拢卢  minibuffer   忙碌   赂枚赂   
(setq display-time-24hr-format t);; 卤录盲 鹿  24 隆 卤  
(setq display-time-day-and-date t);; 卤录盲   戮掳眉 篓    潞 戮  氓 卤录盲
(setq display-time-use-mail-icon t);; 卤录盲 赂  卤  么    录镁 猫  
(setq display-time-interval 10);; 卤录盲碌 卤盲禄炉 碌  拢卢碌楼 禄露    麓  拢驴
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;     戮 卤录盲 猫  陆谩 酶  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;露篓  虏  梅 掳鹿 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 猫  麓貌驴陋  录镁碌  卤 隆 路戮露
;;(setq default-directory "/Users/liliwang/Documents/work/mstar/farm/develop/trunk/client/farmstory/FarmstroyNet/src")

;;ido碌  盲  , 芒赂枚驴    鹿 茫    C-x C-f麓貌驴陋  录镁碌  卤潞貌  潞贸 忙   谩 戮;
;; 芒 茂   卤陆 麓貌驴陋  ido碌  搂鲁 拢卢  emacs23   芒赂枚    麓酶碌 .
(ido-mode t)

(setq visible-bell t)
;;鹿 卤 路鲁  碌 鲁枚麓铆 卤碌  谩 戮 霉
(setq inhibit-startup-message t)
;;鹿 卤 emacs 么露炉 卤碌 禄颅 忙

(setq gnus-inhibit-startup-message t)
;;鹿 卤 gnus 么露炉 卤碌 禄颅 忙

(fset 'yes-or-no-p 'y-or-n-p)
;; 赂 卤盲 Emacs 鹿  麓碌  陋 茫禄 麓冒 yes 碌    陋隆拢掳麓 y 禄貌驴 赂帽录眉卤铆 戮 yes拢卢n 卤铆 戮 no隆拢

(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not  text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))
;;  茂路篓赂   隆拢鲁媒 text-mode  庐 芒碌  拢 陆   鹿   茂路篓赂   隆拢

(setq column-number-mode t) 
(setq line-number-mode t)
;;   戮    潞 

(setq mouse-yank-at-point t)
;;虏禄 陋   贸卤锚碌茫禄梅碌   赂枚碌 路陆虏氓 毛录么 霉掳氓    隆拢  虏禄 虏禄露   霉拢卢戮颅鲁拢掳   碌   碌碌赂茫碌  禄   茫隆拢  戮玫碌     鹿芒卤锚露篓 禄拢卢 禄潞贸 贸卤锚  录眉碌茫禄梅 陋潞 碌 露 隆拢虏禄鹿  茫碌 鹿芒卤锚    碌碌碌   赂枚 禄  拢卢禄貌     minibuffer拢卢 贸卤锚  录眉 禄碌茫禄梅拢卢X selection 碌     戮 卤禄虏氓 毛碌陆  赂枚 禄  隆拢

(setq kill-ring-max 200)
;; 猫   鲁 霉禄潞鲁氓 玫 驴 媒 驴.   禄赂枚潞 麓贸碌 kill ring( 卯露 碌 录  录赂枚 媒).  芒 霉路  鹿  虏禄 隆   戮碌么   陋碌 露芦 梅

;;(setq-default auto-fill-function 'do-auto-fill) 
 ; Autofill in all modes;;
;;(setq default-fill-column 120)
;;掳  fill-column  猫 陋 60.  芒 霉碌     赂眉潞 露 

(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
;;(setq tab-stop-list ())
;;虏禄   TAB   路没 麓indent,  芒禄谩 媒 冒潞 露  忙鹿 碌 麓铆 贸隆拢卤 录颅 Makefile 碌  卤潞貌 虏虏禄  碌拢  拢卢 貌 陋 makefile-mode 禄谩掳  TAB 录眉 猫  鲁  忙 媒碌  TAB   路没拢卢虏垄  录      戮碌 隆拢

(setq sentence-end "\\([隆拢拢隆拢驴]\\|隆颅隆颅\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
;; 猫   sentence-end 驴    露卤冒    卤锚碌茫隆拢虏禄     fill  卤  戮盲潞 潞贸虏氓 毛 陆赂枚驴 赂帽隆拢

(setq enable-recursive-minibuffers t)
;;驴   碌 鹿茅碌  鹿   minibuffer

(setq scroll-margin 3  scroll-conservatively 10000)
;;路  鹿 鲁 忙鹿枚露炉 卤 酶露炉拢卢 scroll-margin 3 驴     驴驴陆眉   禄卤   3   卤戮 驴陋 录鹿枚露炉拢卢驴   潞 潞 碌 驴麓碌陆      隆拢

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill) 
;; 猫   卤 隆 梅 拢 陆  text拢卢,虏垄陆酶 毛auto-fill麓  拢 陆.露酶虏禄  禄霉卤戮 拢 陆fundamental-mode

(setq show-paren-style 'parenthesis)
;; 篓潞  楼 盲 卤驴   赂      戮 铆 芒 禄卤 碌  篓潞 拢卢碌芦鹿芒卤锚虏禄禄谩路鲁  碌  酶碌陆 铆 禄赂枚 篓潞 麓娄隆拢

(setq mouse-avoidance-mode 'animate)
;;鹿芒卤锚驴驴陆眉 贸卤锚 赂 毛 卤拢卢   贸卤锚 赂 毛  露炉  驴陋拢卢卤冒碌虏 隆    隆拢

(setq frame-title-format "emacs@%b")
;;  卤锚 芒 赂   戮buffer碌  没  拢卢露酶虏禄   emacs@wangyin.com  芒 霉 禄  碌  谩 戮隆拢

(setq uniquify-buffer-name-style 'forward);;潞  帽 禄 冒 梅  
;; 碌卤   陆赂枚  录镁 没   卢碌 禄潞鲁氓 卤拢卢 鹿   掳 潞碌  驴 录 没 枚 buffer  没  拢卢虏禄   颅 麓碌 foobar<?>    陆隆拢

(setq auto-image-file-mode t)
;;   Emacs 驴    卤陆 麓貌驴陋潞    戮 录 卢隆拢

;(auto-compression-mode 1)   
;麓貌驴陋 鹿 玫  录镁 卤  露炉陆芒 鹿 玫隆拢

(setq global-font-lock-mode t)
;;陆酶   茂路篓录   隆拢

(setq-default kill-whole-line t)
;;        C-k  卤拢卢 卢 卤 戮鲁媒赂   隆拢

(add-hook 'comint-output-filter-functions
      'comint-watch-for-password-prompt)
;;碌卤 茫  shell隆垄telnet隆垄w3m碌  拢 陆   卤拢卢卤  禄 枚碌陆鹿媒 陋 盲 毛   毛碌  茅驴枚,麓  卤录     鲁枚 茫碌    毛

;; (setq version-control t);; 么  掳忙卤戮驴   拢卢录麓驴   卤赂路 露 麓 
;; (setq kept-old-versions 2);;卤赂路  卯 颅 录碌 掳忙卤戮 陆麓 拢卢录掳碌  禄麓 卤 录颅 掳碌   碌碌拢卢潞 碌 露镁麓 卤 录颅 掳碌   碌碌
;; (setq kept-new-versions 1);;卤赂路  卯  碌 掳忙卤戮1麓 拢卢 铆陆芒 卢  
;; (setq delete-old-versions t);; 戮碌么虏禄 么      3  掳忙卤戮碌 掳忙卤戮
;; (setq backup-directory-alist '(("." . "~/backups")));; 猫  卤赂路   录镁碌  路戮露
;; (setq backup-by-copying t);;卤赂路  猫  路陆路篓拢卢 卤陆 驴陆卤麓
;; Emacs   拢卢赂 卤盲  录镁 卤拢卢 卢  露录禄谩虏煤 煤卤赂路   录镁(   ~ 陆谩 虏碌   录镁)隆拢驴    锚 芦 楼碌么
;; (虏垄虏禄驴  隆)拢卢 虏驴     露篓卤赂路 碌 路陆 陆隆拢 芒 茂虏   碌   拢卢掳  霉  碌   录镁卤赂路 露录路    禄
;; 赂枚鹿 露篓碌 碌 路陆("~/backups")隆拢露    驴赂枚卤赂路   录镁拢卢卤拢 么 卯 颅 录碌  陆赂枚掳忙卤戮潞  卯  碌 
;; 1赂枚掳忙卤戮隆拢虏垄  卤赂路 碌  卤潞貌拢卢卤赂路   录镁  赂麓卤戮拢卢露酶虏禄   颅录镁隆拢

;;(setq make-backup-files nil) 
;;  猫露篓虏禄虏煤 煤卤赂路   录镁

(setq auto-save-mode nil) 
;;  露炉卤拢麓忙 拢 陆

(setq-default make-backup-files nil)
;; 虏禄 煤鲁    卤  录镁

(put 'scroll-left 'disabled nil)     ;   铆   禄 贸  
(put 'scroll-right 'disabled nil)    ;   铆   禄    
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil) 
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
;;掳  芒 漏 卤 隆陆没  碌 鹿娄  麓貌驴陋隆拢

;;   铆emacs潞  芒虏驴 盲 没鲁  貌碌  鲁 霉
(setq x-select-enable-clipboard t)

(setq mouse-yank-at-point t)
;; 鹿   贸卤锚  录眉驴    鲁 霉

;(setq user-full-name " 玫 茂 茂")
(setq user-mail-address "wanglili@mo-star.com")
;; 猫      碌 赂枚     垄, 芒  潞 露 碌 路陆    隆拢

(setq require-final-newline t)
;;   露炉碌     录镁 漏 枚录  禄    

(setq-default transient-mark-mode t)
;;Non-nil if Transient-Mark mode is enabled.

(setq track-eol t)
;; 碌卤鹿芒卤锚     虏      露炉碌  卤潞貌拢卢 录  卤拢鲁      虏隆拢

(setq Man-notify-method 'pushy)
;; 碌卤盲炉   man page  卤拢卢 卤陆  酶 陋碌陆 man buffer隆拢

(setq next-line-add-newlines nil)
;;Emacs 21     戮颅   卤 隆 猫  隆拢掳麓 C-n 禄貌 貌  录眉 卤虏禄 铆录     隆拢
  
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;; 猫  home录眉 赂 貌buffer驴陋 路拢卢end录眉 赂 貌buffer陆谩 虏


(global-set-key (kbd "C-,") 'scroll-left)
;; "C-," 猫 陋   禄 贸   眉 卯
(global-set-key (kbd "C-.") 'scroll-right)
;; "C-." 猫 陋   禄     眉 卯

(global-set-key [f1] 'manual-entry)
(global-set-key [C-f1] 'info )

(global-set-key [f3] 'repeat-complex-command)

(global-set-key [f4] 'other-window)
;;  酶 陋碌陆 Emacs 碌  铆 禄赂枚buffer麓掳驴 

(defun du-onekey-compile ()
  "Save buffers and start compile"
  (interactive)
  (save-some-buffers t)
  (switch-to-buffer-other-window "*compilation*")
  (compile compile-command))
  (global-set-key [C-f5] 'compile)
  (global-set-key [f5] 'du-onekey-compile)
;;  C-f5,  猫  卤  毛 眉 卯; f5, 卤拢麓忙 霉    录镁 禄潞贸卤  毛碌卤 掳麓掳驴   录镁

(global-set-key [f6] 'gdb)             
;;F6 猫   陋  Emacs  碌梅  gdb

(global-set-key [C-f7] 'previous-error)
(global-set-key [f7] 'next-error)

(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))
(global-set-key [(f8)] 'open-eshell-other-buffer)
(global-set-key [C-f8] 'eshell)
;; 驴碌   驴陋 禄赂枚shell碌  隆buffer拢卢    赂眉路陆卤茫碌 虏芒  鲁  貌( 虏戮       鲁  貌  )拢卢  戮颅鲁拢禄谩  碌陆隆拢
;;f8戮    铆驴陋 禄赂枚buffer 禄潞贸麓貌驴陋shell拢卢C-f8 貌    碌卤 掳碌 buffer麓貌驴陋shell

;; (setq speedbar-show-unknown-files t);;驴      戮 霉   驴 录  录掳  录镁
;; (setq dframe-update-speed nil);;虏禄  露炉 垄  拢卢  露炉 g  垄  
;; (setq speedbar-update-flag nil)
;; (setq speedbar-use-images nil);;虏禄 鹿   image 碌 路陆 陆
;; (setq speedbar-verbosity-level 0)

;; (global-set-key [f9] 'speedbar)

;; 猫  f9碌梅  speedbar 眉 卯
;; 鹿   n 潞  p 驴         露炉拢卢
;; +  鹿驴陋 驴 录禄貌  录镁陆酶  盲炉  拢卢-    玫拢卢RET 路    驴 录禄貌  录镁拢卢g 赂眉   speedbar隆拢

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
;;   dired 驴   碌 鹿茅碌 驴陆卤麓潞  戮鲁媒 驴 录隆拢
(global-set-key [C-f9] 'dired)
;; 猫  [C-f9] 陋碌梅  dired 眉 卯

(global-set-key [f10] 'undo)             
;; 猫  F10 陋鲁路 煤

(global-set-key [C-f11] 'calendar) 
;; 猫  F11驴矛陆 录眉 赂露篓Emacs 碌    煤 碌 鲁

(global-set-key [C-f12] 'list-bookmarks)
;; 猫  F12 驴矛  虏矛驴麓  鲁 掳虏  

(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:y-%02m-%02d %3a %02H:%02M:%02S chunyu")
;;  猫   卤录盲麓 拢卢卤锚 露鲁枚 卯潞贸 禄麓 卤拢麓忙  录镁碌  卤录盲隆拢

(global-set-key (kbd "M-g") 'goto-line)
;; 猫  M-g 陋goto-line

(global-set-key (kbd "C-SPC") 'nil)
;; 隆 没control+space录眉 猫 陋mark

(global-set-key (kbd "M-<SPC>") 'set-mark-command)
;; 芒 霉   戮 虏禄  掳麓 C-@  麓 setmark   , C-@ 潞 虏禄潞 掳麓隆拢

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;露篓  虏  梅 掳鹿 陆谩 酶;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;======================= cscope  猫   =======================
;; 鹿   cscope 盲炉   麓麓煤 毛, 芒赂枚xcscope  赂枚赂 陆酶掳忙拢卢 陋 驴 禄麓 虏茅  碌 陆谩鹿没 鹿  虏禄 卢 buffer 拢卢
;; 芒 霉戮 驴   卤拢麓忙   掳碌 陆谩鹿没隆拢

;;(add-to-list 'load-path  "/Applications/Emacs.app/Contents/Resources/lisp/xcscope") ;; 陆芦 铆录镁掳眉 霉  碌  路戮露录 碌陆 EMACS 碌  load-path
;;(require 'xcscope) ;; 录      娄碌  铆录镁

;; C-c s a              猫露篓鲁玫 录禄炉碌  驴 录拢卢 禄掳茫   茫麓煤 毛碌 赂霉 驴 录
;; C-s s I             露  驴 录  碌   鹿   录镁陆篓 垄  卤铆虏垄陆酶   梅 媒
;; C-c s s              貌  路没潞 
;; C-c s g              掳   芦戮 碌 露篓 氓
;; C-c s c             驴麓驴麓 赂露篓潞炉 媒卤禄   漏潞炉 媒 霉碌梅  
;; C-c s C             驴麓驴麓 赂露篓潞炉 媒碌梅       漏潞炉 媒
;; C-c s e              掳   媒 貌卤铆麓茂 陆
;; C-c s f              掳    录镁
;; C-c s i             驴麓驴麓 赂露篓碌   录镁卤禄   漏  录镁include


;;tabar
;======================== 
;; (require 'tabbar)
;; (tabbar-mode)

;======================= wb-line-number 猫   ================== 
;; 枚录  禄赂枚   戮  潞 碌 buffer
;(add-to-list 'load-path  "/Users/liliwang/Library/Preferences/Aquamacs Emacs/lisp/wb-line-number")
;(require 'wb-line-number)
;(wb-line-number-enable)
;====================== wb-line-number 猫  陆谩 酶 ================


;=====================  info  录镁 猫   ==============================
;;Info 碌 虏 碌楼  掳麓 Info-directory-list 碌  鲁 貌  鲁枚碌 拢卢露酶 Info-directory-list      么露炉 info  卤
;;  Info-default-directory-list  麓鲁玫 录碌 隆拢 霉   陋 铆录  Info  驴 录   陋 猫   Info-default-directory-list隆拢
;;   铆录 碌  Info  驴 录  拢卢麓麓陆篓 禄赂枚陆  dir 碌   录镁拢篓 盲 碌 霉   Info-directory-list  茂   禄赂枚  录镁戮     拢卢
;;   ${emacs}/info   录镁录      芒赂枚  录镁拢卢  赂  芒赂枚 虏驴   拢漏隆拢

(add-to-list 'Info-default-directory-list  "/Applications/Emacs.app/Contents/Resources/info")

;; N拢潞 酶 陋碌陆赂 陆 碌茫碌    禄赂枚陆 碌茫拢禄           
;; P拢潞 酶 陋碌陆赂 陆 碌茫碌    禄赂枚陆 碌茫拢禄
;; M:  赂露篓虏 碌楼 没露酶 隆 帽 铆 芒 禄赂枚陆 碌茫拢禄
;; F拢潞陆酶 毛陆禄虏忙 媒   梅 芒拢禄
;; L拢潞陆酶 毛赂 麓掳驴   碌  卯潞贸 禄赂枚陆 碌茫拢禄
;; TAB拢潞 酶 陋碌陆赂 麓掳驴 碌    禄赂枚鲁卢  卤戮 麓陆 拢禄
;; RET拢潞陆酶 毛鹿芒卤锚麓娄碌 鲁卢  卤戮 麓陆 拢禄
;; U拢潞 陋碌陆   禄录露 梅 芒拢禄
;; D拢潞禄 碌陆 INFO 碌 鲁玫 录陆 碌茫 驴 录拢禄
;; H拢潞碌梅鲁枚 INFO 陆 鲁 拢禄
;; Q拢潞  鲁枚 INFO隆拢

;===================  INFO  录镁 猫  陆谩 酶 ============================


;;=========================== 路陆卤茫卤 鲁 虏  梅碌  猫  =====================================

(setq compile-command "make")
;;emacs碌  卢  compile 眉 卯  碌梅  make -k拢卢  掳  眉赂 鲁   make隆拢 茫 虏驴   掳  眉赂 鲁  盲 没碌 拢卢卤  莽gcc 庐  碌 .

;;掳 c 茂  路莽赂帽 猫   陋k&r路莽赂帽
(add-hook 'c-mode-hook
'(lambda ()
(c-set-style "k&r")))

;;掳 C++ 茂  路莽赂帽 猫   陋stroustrup路莽赂帽
(add-hook 'c++-mode-hook
'(lambda()
(c-set-style "stroustrup")))

;========================================================================

;; (defun my-c-mode-auto-pair ()
;;   (interactive)
;;   (make-local-variable 'skeleton-pair-alist)
;;   (setq skeleton-pair-alist  '(
;;     (?` ?` _ "''")
;;     (?\( ?  _ ")")
;;     (?\[ ?  _ "]")
;;     (?{ \n > _ \n ?} >)))
;;   (setq skeleton-pair t)
;;   (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;;   (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;;   (local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
;;   (local-set-key (kbd "[") 'skeleton-pair-insert-maybe))
;; (add-hook 'c++-mode-hook 'my-c-mode-auto-pair)
;; (add-hook 'c-mode-hook 'my-c-mode-auto-pair)

;; 盲 毛 贸卤 碌  篓潞 拢卢戮 禄谩  露炉虏鹿 芦  卤 碌 虏驴路 .掳眉 篓(), "", [] , {} , 碌 碌 隆拢

;=========================================================================

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
 '(tags-table-list (quote ("/Users/renren/work/cocos2d-x-2.2/")))
 '(tooltip-hide-delay 120)
 '(w3m-command "C:/w3m-0.5.1-2/usr/bin/w3m.exe"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;=========== shell-mode
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t) 
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t) 

;=========== lua-mode
;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp")
;;(require 'lua-mode)

;; 猫  emacs  卤 录颅.lua  录镁碌  卤潞貌  露炉  禄禄碌陆lua-mode 拢 陆
;;(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
;;(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;;驴陋 么Lua麓煤 毛 盲 芦
;;(add-hook 'lua-mode-hook 'turn-on-font-lock)

;;驴陋 么lua 镁虏  鲁露 麓煤 毛驴茅鹿娄  
;;(add-hook 'lua-mode-hook 'hs-minor-mode)

;=========== auto-complete
;;(add-to-list 'load-path "C:/emacs-23.2/site-lisp/auto-complete-1.3.1")
;;(require 'auto-complete-config)  
;;(add-to-list 'ac-dictionary-directories  "/Users/liliwang/Documents/auto-complete/ac-dict")  
;;(ac-config-default)
;;(add-to-list ac-modes (lua-mode, muse-mode, org-mode))

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq-default ac-sources '(ac-source-words-in-same-mode-buffers))
(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))
(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue") ;;;  猫  卤    忙陆  录  赂眉潞 驴麓碌 卤鲁戮掳   芦
(define-key ac-completing-map "\M-n" 'ac-next)  ;;;   卤铆   篓鹿媒掳麓M-n 麓 貌    露炉
(define-key ac-completing-map "\M-p" 'ac-previous)
(setq ac-auto-start 2)
(setq ac-dwim t)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

;;2013-9-27
(add-to-list 'ac-modes 'objc-mode)

;;========== pymacs
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;;=========== org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-startup-indented t)

;;=========== linum
(require 'linum)
(global-linum-mode 1)

;;=============12-21
(tool-bar-mode -1) ;;虏禄   戮鹿陇戮  赂 鹿陇戮  赂 芦鲁贸

;;; --- 卤  毛 猫  
(setq default-buffer-file-coding-system 'utf-8-unix)            ;禄潞麓忙  录镁卤  毛
(setq default-file-name-coding-system 'utf-8-unix)              ;  录镁 没卤  毛
(setq default-keyboard-coding-system 'utf-8-unix)               ;录眉   盲 毛卤  毛
(setq default-process-coding-system '(utf-8-unix . utf-8-unix)) ;陆酶鲁  盲鲁枚 盲 毛卤  毛
(setq default-sendmail-coding-system 'utf-8-unix)               ;路垄    录镁卤  毛
(setq default-terminal-coding-system 'utf-8-unix)               ;  露 卤  毛

;;======sr-speedbar
(require 'sr-speedbar)
(require 'speedbar-extension)
(global-set-key [f9] 'sr-speedbar-toggle)
(global-set-key (kbd "C-c b b") 'sr-speedbar-select-window)
;;默认显示所有文件                                                                                                                             
                                                                                                                                              
;;sr-speedbar-right-side 把speedbar放在左侧位置                                                                                                
;;sr-speedbar-skip-other-window-p 多窗口切换时跳过speedbar窗口                                                                                 
;;sr-speedbar-max-width与sr-speedbar-width-x 设置宽度                                                                                          

;; 绑定快捷键                                                                                                        

;;2013-2-9
(show-paren-mode 1)
(global-unset-key "\C-xf")

;;2013-2-16
(setq w32-get-true-file-attributes nil)
;;2013-3-19
(global-set-key (kbd "C-;") 'yas/expand)

;;2013-3-20
;;============================== bm
(require 'bm)
(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)
(global-set-key (kbd "\C-cbs") 'bm-show-all)
(global-set-key (kbd "\C-cbr") 'bm-remove-all-all-buffers)

;;==============================anything
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
;;(set-default-font "Menlo Regular-15")


;;2013-9-27
(setq auto-mode-alist
      (cons '("\\.mm$" . objc-mode) auto-mode-alist))

;;2013-10-20
;;TODO
(setq todo-file-do "~/todo/do")
(setq todo-file-done "~/todo/done")
(setq todo-file-top "~/todo/top")

(setq calendar-latitude +39.54)
(setq calendar-longitude +116.28)
(setq calendar-location-name "卤卤戮漏")

;;  猫   玫 煤   戮拢卢   calendar      pC    戮 玫 煤
(setq chinese-calendar-celestial-stem
["录 " "  " "卤没" "露隆" " 矛" "录潞" "赂媒" "  " "  " "鹿茂"])
(setq chinese-calendar-terrestrial-branch
["  " "鲁贸" " 煤" " 庐" "鲁陆" "  " " 矛" " 麓" " 锚" "  " " 莽" "潞楼"])

;;  猫   calendar 碌    戮
(setq calendar-remove-frame-by-deleting t)
(setq calendar-week-start-day 1) ;  猫       禄 陋 驴  碌 碌  禄 矛
(setq mark-diary-entries-in-calendar t) ; 卤锚录 calendar    diary碌     
(setq mark-holidays-in-calendar nil) ;  陋   禄鲁枚  diary碌     拢卢calendar  虏禄卤锚录 陆   
(setq view-calendar-holidays-initially nil) ; 麓貌驴陋calendar碌  卤潞貌虏禄   戮 禄露 陆    

;;  楼碌么虏禄鹿   碌 陆   拢卢 猫露篓  录潞   芒碌 陆   拢卢   calendar      h    戮陆   
(setq christian-holidays nil)
(setq hebrew-holidays nil)
(setq islamic-holidays nil)
(setq solar-holidays nil)
(setq general-holidays '((holiday-fixed 1 1 " 陋碌漏")
(holiday-fixed 2 14 " 茅  陆 ")
(holiday-fixed 3 14 "掳  芦 茅  陆 ")
(holiday-fixed 4 1 "    陆 ")
(holiday-fixed 5 1 "  露炉陆 ")
(holiday-float 5 0 2 " 赂  陆 ")
(holiday-fixed 6 1 "露霉 炉陆 ")
(holiday-float 6 0 3 "赂赂  陆 ")
(holiday-fixed 7 1 "陆篓碌鲁陆 ")
(holiday-fixed 8 1 "陆篓戮眉陆 ")
(holiday-fixed 9 10 "陆  娄陆 ")
(holiday-fixed 10 1 "鹿煤 矛陆 ")
(holiday-fixed 12 25 " 楼碌庐陆 ")))

(setq diary-file "~/diary/diary")

;;2013-11-6
(require 'lua-block)
(lua-block-mode t)
;; do overlay
;;(setq lua-block-highlight-toggle 'overlay)
;; display to minibuffer
;;(setq lua-block-highlight-toggle 'minibuffer)
;; display to minibuffer and do overlay
(setq lua-block-highlight-toggle t)

(add-hook 'lua-mode-hook 'hs-minor-mode)

;;2013-11-7
;; (require 'cursor-chg)  ; Load this library
;; (change-cursor-mode 1) ; On for overwrite/read-only/input mode
;; (toggle-cursor-type-when-idle 1) ; On when idle

;; 鹿  Emacs-w3m盲炉   酶 鲁
;; (add-to-list 'load-path "~/emacs/site-lisp/w3m")
;; (require 'w3m-load)
;; (require 'w3m-e21)
;; (provide 'w3m-e23)
;; (setq w3m-use-favicon nil)
;; (setq w3m-command-arguments '("-cookie" "-F"))
;; (setq w3m-use-cookies t)
;; (setq w3m-home-page "http://www.google.com")

;; (setq w3m-display-inline-image t)

;; 么露炉潞 鲁玫 录禄炉w3m.el
;;(add-to-list 'exec-path "D:/w3m-0.5.1-2/usr/bin")
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-search "w3m-search" "Search words using emacs-w3m." t)
;; 鹿  w3m 梅 陋 卢  碌 盲炉   梅
(setq browse-url-browser-function 'w3m-browse-url)
;; 鹿  mule-ucs拢卢 禄     茫掳虏 掳mule-ucs elisp 漏 鹿掳眉 卤 芒赂枚虏     拢卢驴   驴麓Unicode陆芒 毛碌  酶 鲁
;(setq w3m-use-mule-ucs t)
;; 鹿  鹿陇戮 掳眉
(setq w3m-use-toolbar t)
;; 鹿  info碌 驴矛录镁录眉掳贸露篓
;(set-default 'w3m-key-binding 'info)
;; 么  cookie
(setq w3m-use-cookies t)
;; 芒赂枚   梅 虏 麓碌 ?
(setq w3m-use-tab-menubar t)
;; 猫露篓w3m 录卤锚 霉    录镁录 
;(setq w3m-icon-directory "/home/jerry/software/xemacs/w3m/emacs-w3m-1.4.4/icons")
;;   戮 录卤锚
(setq w3m-show-graphic-icons-in-header-line t)
(setq w3m-show-graphic-icons-in-mode-line t)
;; 猫露篓w3m    碌 虏  媒拢卢路 卤冒 陋 鹿  cookie潞  鹿  驴貌录 
(setq w3m-command-arguments '("-cookie" "-F"))
;;  w3m盲炉   酶 鲁 卤 虏   戮 录 卢
;;(setq w3m-display-inline-image t)
;; ;; 猫露篓w3m碌  茂   猫  拢卢  卤茫路陆卤茫 鹿  潞   露     -    戮    毛
;; ;; 茅 漏陆芒 毛 猫  
;; (setq w3m-bookmark-file-coding-system 'chinese-iso-8bit)
;; ;;w3m碌 陆芒 毛 猫  拢卢潞贸 忙 卯潞 露录  拢卢   虏虏禄 锚陆芒  
;; (setq w3m-coding-system 'chinese-iso-8bit)
;; (setq w3m-default-coding-system 'chinese-iso-8bit)
;; (setq w3m-file-coding-system 'chinese-iso-8bit)
;; (setq w3m-file-name-coding-system 'chinese-iso-8bit)
;; (setq w3m-terminal-coding-system 'chinese-iso-8bit)
;; (setq w3m-input-coding-system 'chinese-iso-8bit)
;; (setq w3m-output-coding-system 'chinese-iso-8bit)
;;w3m   鹿  tab碌 拢卢 猫露篓Tab碌 驴铆露 
(setq w3m-tab-width 8)
;; 猫露篓w3m碌  梅 鲁
(setq w3m-home-page "http://www.google.com")
;;碌卤   shift+RET 麓貌驴陋   麓陆  卤陆芦虏禄  露炉 酶 陋碌陆  碌  鲁 忙拢卢碌  谩 戮  戮颅 锚 芦麓貌驴陋拢卢虏    C-c C-n 拢卢
;;C-c C-p 麓貌驴陋拢卢 芒赂枚潞   
(setq w3m-view-this-url-new-session-in-background t)
(add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)
;;潞  帽     没         梅碌 
(defun remove-w3m-output-garbages ()
" 楼碌么w3m 盲鲁枚碌  卢禄酶."
(interactive)
(let ((buffer-read-only))
(setf (point) (point-min))
(while (re-search-forward "[\200-\240]" nil t)
(replace-match " "))
(set-buffer-multibyte t))
(set-buffer-modified-p nil))
;;   芦 猫  
;(setq w3m-
;;;;;;;;;;;;;;;;;;;;;
;; 茂   猫  
;; 芒赂枚虏禄 陋碌      禄拢卢潞  帽     禄掳忙emacs露 unicode 搂鲁 潞   戮 驴     
;;碌卤 禄 芒赂枚    emacs-cvs
;;;;;;;;;;;;;;;;;;;;;
(when (boundp 'utf-translate-cjk)
(setq utf-translate-cjk t)
(custom-set-variables
'(utf-translate-cjk t)))
(if (fboundp 'utf-translate-cjk-mode)
(utf-translate-cjk-mode 1))


;;sdcv瀛  
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)
;;(setq sdcv-program-path "/opt/local/bin/sdcv")
(setq sdcv-program-path "C:/StarDict/stardict.exe")
(require 'emacs-rc-sdcv)

;;=================== the font for Chinese ===============;
;; (create-fontset-from-fontset-spec
;;  "-*-courier-medium-R-normal--17-*-*-*-*-*-fontset-mymono,
;; chinese-gb2312:-*-wenquanyi bitmap song-medium-*-normal--15-*-*-*-*-*-iso10646-1,
;; chinese-gbk:-*-wenquanyi bitmap song-medium-*-normal--15-*-*-*-*-*-iso10646-1,
;; chinese-gb18030:-*-wenquanyi bitmap song-medium-*-normal--15-*-*-*-*-*-iso10646-1"
;;  )
;; ;;(setq default-frame-alist (append '((font . "fontset-mymono")) default-frame-alist))
;; ;;(set-default-font "fontset-mymono")
;; (set-language-environment 'UTF-8) 
;; ;(set-keyboard-coding-system 'utf-8)
;; ;(set-clipboard-coding-system 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (modify-coding-system-alist 'process "*" 'utf-8)
;; (setq default-process-coding-system '(utf-8 . utf-8))
;; (setq-default pathname-coding-system 'utf-8)
;; (set-file-name-coding-system 'utf-8)
;; ;(setq ansi-color-for-comint-mode t) ;;麓娄 铆shell-mode   毛,潞  帽 禄 梅  

;; (set-keyboard-coding-system 'euc-cn)
;; (set-buffer-file-coding-system 'euc-cn)
;; (set-selection-coding-system 'euc-cn)
;;(set-clipboard-coding-system 'chinese-iso-8bit-with-esc)


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

;;jde
;;====================
;; (require 'jde)
;; (setq jde-check-version-flag nil)
;; (define-obsolete-function-alias 'make-local-hook 'ignore "21.1")
;; (unless (fboundp 'semantic-format-prototype-tag-java-mode)
;;   (defalias 'semantic-format-prototype-tag-java-mode 'semantic-format-tag-prototype-java-mode))
;; (require 'hippie-exp)

;; (autoload 'jde-mode "jde" "JDE mode." t)
;; (setq auto-mode-alist
;;       (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))

;; (setq jde-help-remote-file-exists-function '("beanshell"))
;; (setq jde-enable-abbrev-mode t)

;;====================
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
      '((basedir          "~/work/qt/c2dqt/c2dqt/")
        (src-patterns     ("*.lua" "*.cpp" "*.h" "*.mm" "*.m" "*.hpp" "*.c"))
        (ignore-patterns  ("*.svn" "*.out" "#*#" "*.o" "*.pkg" "*cscope*" "*obj*" "*vcxproj*"))
        ;;(ignore-directorys ("*CoolBox.xcodeproj*" "*git*")) 
        ;;(search-directorys ())
        (tags-file        "~/mk-project/c2dqt/TAGS")
        (file-list-cache  "~/mk-project/c2dqt/FILES")
        (open-files-cache "~/mk-project/c2dqt/OPEN-FILES")
        (vcs              svn)
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

;;
(require 'dired+)

(require 'ediff-trees)
(global-set-key (kbd "M-N") 'ediff-trees-examine-next)
(global-set-key (kbd "M-P") 'ediff-trees-examine-previous)
(global-set-key (kbd "C-s-SPC") 'ediff-trees-examine-next-regexp)
(global-set-key (kbd "C-S-s-SPC") 'ediff-trees-examine-previous-regexp)
