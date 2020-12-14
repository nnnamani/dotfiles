;; Install leaf.el
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))

  (when load-file-name
    (setq user-emacs-directory (file-name-directory load-file-name)))

  (defvar bootstrap-version)
  (let ((bootstrap-file
	     (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
	    (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
	      (url-retrieve-synchronously
	       "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	       'silent 'inhibit-cookies)
	    (goto-char (point-max))
	    (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  (straight-use-package 'leaf)
  (straight-use-package 'leaf-keywords))


(leaf *standard-configuration
  :config

  (leaf exec-path-from-shell
    :ensure t
    :when (memq window-system '(mac ns x))
    :config
    (exec-path-from-shell-initialize))

  (setq-default bidi-display-reordering nil)

  (set-language-environment 'Japanese)

  (set-keyboard-coding-system 'utf-8)

  (setq buffer-file-coding-system 'utf-8-unix)

  (prefer-coding-system 'utf-8-unix)

  (blink-cursor-mode 0)

  (setq inhibit-startup-message t)

  (fset 'yes-or-no-p 'y-or-n-p)

  (setq backup-directory-alist
        `((".*" . ,(expand-file-name (concat user-emacs-directory "/backup")))))

  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name (concat user-emacs-directory "/backup")) t)))

  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))

  (when (member "Myrica M" (font-family-list))
    (set-frame-font "Myrica M-11"))

  (global-font-lock-mode +1)

  (show-paren-mode t)

  (transient-mark-mode 1)

  (scroll-bar-mode -1)

  (menu-bar-mode -1)

  (tool-bar-mode -1)

  (line-number-mode 0)

  (column-number-mode 0)

  (delete-selection-mode t)

  (setq-default indent-tabs-mode nil)

  (setq-default tab-width 4))


(leaf *key-binding
  :config
  (leaf *global
    :config
    (global-set-key (kbd "C-h") #'backward-delete-char)
    (global-set-key (kbd "s-u") #'revert-buffer)))


(leaf doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)
  
  (doom-themes-neotree-config)
  ;;(doom-themes-treemacs-config)
  (doom-themes-org-config))

(leaf *mode-lines
  :config
  (leaf nyan-mode
    :ensure t
    :straight t
    :custom
    (nyan-animate-nyancat . t)
    :hook
    (emacs-startup-hook . nyan-mode))

  (leaf doom-modeline
    :ensure t
    :straight t
    :commands doom-modeline-def-modeline
    :custom
    (doom-modeline-buffer-file-name-style . 'truncate-with-project)
    (doom-modeline-icon . t)
    (doom-modeline-major-mode-icon . t)
    (doom-modeline-minor-modes . nil)
    :hook
    (emacs-startup-hook . doom-modeline-mode)
    :config
    (doom-modeline-def-modeline
      'main
      '(bar window-number modals matches buffer-info remote-host buffer-position selection-info)
      '(misc-info debug minor-modes input-method lsp major-mode process vcs checker)))

  (leaf hide-mode-line
    :ensure t
    :straight t
    :hook
    (imenu-list-major-mode-hook . hide-mode-line-mode)))


;; Search/Replace
(leaf ag
  :ensure t)

(leaf anzu
  :ensure t
  :config
  (global-anzu-mode 1))

(leaf ivy
  :ensure t swiper counsel
  :hook (after-init-hook . ivy-mode)
  :custom
  (ivy-use-virtual-buffers . t)
  (enable-recursive-minibuffers . t)
  (ivy-height . 15)
  (ivy-extra-directories . nil)
  (ivy-re-builders-alist. '((t . ivy--regex-plus)))
  :config
  (global-set-key "\C-s" 'swiper)
  (global-set-key "\C-r" 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  (defvar swiper-include-line-number-in-search t)

  (leaf avy-migemo
    :ensure t
    :hook (ivy-mode-hook . avy-migemo-mode))

  (leaf ivy-rich
    :ensure t all-the-icons-ivy all-the-icons
    :hook (ivy-mode-hook . ivy-rich-mode)
    :preface
    (defun ivy-rich-switch-buffer-icon (candidate)
      (with-current-buffer
          (get-buffer candidate)
        (let ((icon (all-the-icons-icon-for-mode major-mode)))
          (if (symbolp icon)
              (all-the-icons-icon-for-mode 'fundamental-mode)
            icon))))
    :config
    (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-arrow)
    (setq ivy-rich--display-transformers-list
          '(ivy-switch-buffer
            (:columns
             ((ivy-rich-switch-buffer-icon :width 2)
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
             :predicate
             (lambda (cand) (get-buffer cand)))))))


;; Helpers
(leaf ace-window
  :ensure t
  :bind
  (("C-x o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :custom-face
  (aw-leading-char-face . '((t (:height 3.0)))))

(leaf company
  :ensure t
  :bind
  ((:company-active-map
    ("C-n" . company-select-next)
    ("C-p" . company-select-previous)
    ("<tab>" . company-complete-selection)
    ("C-h" . nil)
    ("C-S-h" . company-show-doc-buffer)))
  :hook
  `((after-init . global-company-mode)
    (minibuffer-setup-hook . ,(lambda ()
                                (company-mode -1))))
  :custom
  ((company-idle-delay . 0)
   (company-selection-wrap-around . t)))  

(leaf *ghq
  :after ivy
  :init
  (defun ghq--root ()
    (car (split-string (shell-command-to-string "ghq root"))))
  (defun ghq--github-file-list ()
    (let ((github-dir (mapconcat 'identity (list (ghq--root) "github.com") "/")))
      (split-string (shell-command-to-string (concat "find " github-dir " -type d -name .git -prune -o -type f -print")))))
  (defun ghq-ivy-find-file ()
    (interactive)
    (ivy-read "Search file in ghq github.com root: "
              (ghq--github-file-list)
              :action '(1
                        ("o" (lambda (x)
                               (find-file x))))))
  :bind
  ("C-c C-g C-f" . ghq-ivy-find-file))

(leaf org
  :ensure t
  :config
  (setq system-time-locale "C")
  (leaf org-capture
    :config
    (setq work-directory "~/.org/")
    (setq gtd-directory "~/.gtd/")
    (setq gtd-inbox (concat gtd-directory "Inbox.org"))
    (setq gtd-idea (concat gtd-directory "Idea.org"))
    (setq taskfile (concat work-directory "TODO.org"))
    (setq notefile (concat work-directory "NOTE.org"))
    (setq org-capture-templates
	      '(("t" "タスク（スケジュールなし）" entry (file+headline gtd-inbox "Inbox")
             "** TASK %?\n   CREATED: %U\n")
            ("s" "タスク（スケジュールあり）" entry (file+headline taskfile "Tasks")
             "** TODO %?\n   SCHEDULED: %^t\n")
            ("n" "メモ" entry (file+headline notefile "Notes")
             "** %? \n   CREATED: %U\n")
            ("i" "アイデア" entry (file+headline gtd-idea "Idea")
             "** %?\n   CREATED: %U\n")))
    (setq org-todo-keywords
          '((sequence "TASK(t)" "WAIT(w)" "|" "DONE(d)" "ABORT(a)" "SOMEDAY(s)")))
    (setq org-tag-alist '(("PROJECT" . ?p) ("MEMO" . ?m) ("PETIT" . ?t)))
    (setq org-agenda-files (list work-directory gtd-directory))
    (defun show-org-buffer (file)
      "Show an org-file FILE on the current buffer."
      (interactive)
      (if (get-buffer file)
	      (let ((buffer (get-buffer file)))
	        (switch-to-buffer buffer)
	        (message "%s" file))
	    (find-file file)))
    (global-set-key (kbd "C-c o c") #'org-capture)
    (global-set-key (kbd "C-c o n") '(lambda () (interactive)
					                    (show-org-buffer taskfile)))
    (global-set-key (kbd "C-c o i") '(lambda () (interactive)
					                    (show-org-buffer gtd-idea)))
    (global-set-key (kbd "C-c o t") '(lambda () (interactive)
					                   (show-org-buffer gtd-inbox)))
    (global-set-key (kbd "C-c o a") #'org-agenda)))

(leaf counsel-projectile
  :ensure (projectile)
  :bind
  (:projectile-mode-map
   ("C-c p" . projectile-command-map))
  :config
  (counsel-projectile-mode 1))

(leaf rainbow-delimiters
  :ensure t
  :hook ((prog-mode-hook) . rainbow-delimiters-mode))

(leaf undo-tree
  :ensure t
  :bind
  ("M-/" . undo-tree-redo)
  ("M-u" . undo-tree-visualize)
  :config
  (global-undo-tree-mode))
  
(leaf which-key
  :ensure t
  :config
  (which-key-mode))

(leaf yasnippet
  :ensure t
  :require t
  :defun yas-global-mode
  :bind
  (:yas-minor-mode-map
   ("C-x i i" . yas-insert-snippet)
   ("C-x i n" . yas-new-snippet)
   ("C-x i v" . yas-visit-snippet-file)
   ("C-x i l" . yas-describe-tables)
   ("C-x i g" . yas-reload-all))
  :hook
  (after-init . yas-global-mode)
  :config
  (setq yas-prompt-functions '(yas-ido-prompt)))


;; Cursor
(leaf multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))


;; Shell/Term
(leaf *eshell
  :config
  (setq eshell-prompt-function
	    (lambda ()
	      (format "%s %s\n%s%s%s "
		          (all-the-icons-octicon "repo")
		          (propertize (cdr (shrink-path-prompt default-directory)) 'face `(:foreground "white"))
		          (propertize "❯" 'face `(:foreground "#ff79c6"))
		          (propertize "❯" 'face `(:foreground "#f1fa8c"))
		          (propertize "❯" 'face `(:foreground "#50fa7b")))))

  (setq eshell-hist-ignoredups t)
  (setq eshell-cmpl-cycle-completions nil)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-prompt-regexp "❯❯❯ ")
  (add-hook 'eshell-mode-hook
	        '(lambda ()
	           (progn
		         (define-key eshell-mode-map "\C-a" 'eshell-bol)
		         (define-key eshell-mode-map "\C-r" 'counsel-esh-history)
		         (define-key eshell-mode-map [up] 'previous-line)
		         (define-key eshell-mode-map [down] 'next-line)
                 (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)
		         ))))


;; Languages
(leaf *common-lisp
  :config
  (leaf *roswell-slime
    :config
    (when (file-exists-p "~/.roswell/helper.el")
      (load (expand-file-name "~/.roswell/helper.el"))))
  (leaf *qlot
    :config
    (defun slime-qlot-exec (directory)
      (interactive (list (read-directory-name "Project directory: ")))
      (slime-start :program "qlot"
		           :program-args '("exec" "ros" "-S" "." "run")
		           :directory directory
		           :name 'qlot
		           :env (list (concat "PATH=" (mapconcat 'identity exec-path ":")))))))

(leaf json-reformat
  :ensure t)

(leaf rust-mode
  :ensure (cargo company flycheck flycheck-rust lsp-mode lsp-ui)
  :hook
  (rust-mode-hook . cargo-minor-mode)
  (rust-mode-hook . (lambda ()
		              (flycheck-rust-setup)
		              (setq lsp-rust-server 'rust-analyzer)
		              (lsp)
		              (flycheck-mode)))
  :config
  (setq lsp-prefer-capf t)
  (setq rust-format-on-save t))


