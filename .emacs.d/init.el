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
    (global-display-line-numbers-mode)))


(leaf *global-modes
  :config

  (global-font-lock-mode +1)

  (show-paren-mode t)

  (transient-mark-mode 1)

  (scroll-bar-mode -1)

  (menu-bar-mode -1)

  (tool-bar-mode -1)
  (line-number-mode 0)
  (column-number-mode 0))


(leaf *key-binding
  :config
  (leaf *global
    :config
    (global-set-key (kbd "C-h") #'backward-delete-char)))

(leaf doom-themes
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
    :straight t
    :custom
    (nyan-animate-nyancat . t)
    :hook
    (emacs-startup-hook . nyan-mode))

  (leaf doom-modeline
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
    :straight t
    :hook
    (imenu-list-major-mode-hook . hide-mode-line-mode)))
