(require 'package)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; add melpa and orgmode for packages
(add-to-list 'package-archives
      '("melpa" . "https://melpa.org/packages/"))
(unless package-archive-contents
  (package-refresh-contents))

;;; ensure to use use-package
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

;;; use-package always-ensure
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;;; exec path from shell
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(defun mark-word-at-point ()
  (interactive)
  (let ((char (char-to-string (char-after (point)))))
    (cond
     ((string= " " char) (delete-horizontal-space))
     ((string-match "[\t\n -@\[-`{-~]" char) (mark-word ))
     (t (forward-char) (backward-word) (mark-word 1)))))

;;; key binds
(progn
  (define-key global-map (kbd "\C-h") 'delete-backward-char)
  (define-key global-map (kbd "\C-c \C-f") 'toggle-frame-fullscreen)
  (define-key global-map (kbd "\C-c TAB") 'mark-word-at-point)
  (define-key global-map (kbd "\C-c \C-g") 'magit))

;;; beep音を消す
(defun my-bell-function ()
  (unless (memq this-command
                '(isearch-abort abort-recursive-edit exit-minibuffer
                                keyboard-quit mwheel-scroll down up next-line previous-line
                                backward-char forward-char))
    (ding)))

;;; window settings
(defun initialize-local ()
  (set-frame-size (selected-frame) 120 80)
  (tool-bar-mode 0)
  (set-scroll-bar-mode nil)
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message "")
  (setq ring-bell-function 'my-bell-function)
  (set-default-coding-systems 'utf-8)
  (prefer-coding-system 'utf-8)
  (delete-selection-mode t) ; リージョンを削除可能に設定

  ;; インデント設定
  (setq-default tab-width 4
                indent-tabs-mode nil)

  (load-theme 'misterioso t)

  ;; カーソルの色を変更
  (set-cursor-color 'yellow)

  ;; 対応する括弧を強調表示する
  (show-paren-mode t)

  ;; y/nで回答する
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; disable default auto save functions.
  (setq auto-save-default nil
        make-backup-files nil
        delete-auto-save-files nil)

  ;; show trailing spaces.
  (setq-default show-trailing-whitespace nil)
  (add-hook 'prog-mode-hook 'turn-on-show-trailing-whitespace)
  (add-hook 'org-mode-hook 'turn-on-show-trailing-whitespace)
  )

;;; show trailing whitespace.
(defun turn-on-show-trailing-whitespace ()
  (interactive)
  (setq show-trailing-whitespace t))

(defun turn-off-show-trailing-whitespace ()
  (interactive)
  (setq show-trailing-whitespace nil))

(defun toggle-show-trailing-whitespace ()
  (interactive)
  (callf null show-trailing-whitespace))

(initialize-local)

(use-package golden-ratio
  :config
  (golden-ratio-mode 0))

(progn
  (cua-mode t)
  (setq cua-enable-cua-keys nil))

;;; use auto saving buffer enhanced.
;; (use-package real-auto-save
;;   :config
;;   (setq real-auto-save-interval 10)
;;   (add-hook 'prog-mode-hook 'real-auto-save-mode))

;; Powerline
(use-package powerline :defer t
  :init
  (progn
    (defun powerline-my-theme ()
      "Setup the my mode-line."
      (interactive)
      (setq powerline-current-separator 'utf-8)
      (setq-default mode-line-format
                    '("%e"
                      (:eval
                       (let* ((active (powerline-selected-window-active))
                              (mode-line (if active 'mode-line 'mode-line-inactive))
                              (face1 (if active 'mode-line-1-fg 'mode-line-2-fg))
                              (face2 (if active 'mode-line-1-arrow 'mode-line-2-arrow))
                              (separator-left (intern (format "powerline-%s-%s"
                                                              (powerline-current-separator)
                                                              (car powerline-default-separator-dir))))
                              (lhs (list (powerline-raw " " face1)
                                         (powerline-major-mode face1)
                                         (powerline-raw " " face1)
                                         (funcall separator-left face1 face2)
                                         (powerline-buffer-id nil )
                                         (powerline-raw " [ ")
                                         (powerline-raw mode-line-mule-info nil)
                                         (powerline-raw "%*")
                                         (powerline-raw " |")
                                         (powerline-process nil)
                                         (powerline-vc)
                                         (powerline-raw " ]")))
                              (rhs (list (powerline-raw "%4l")
                                         (powerline-raw ":")
                                         (powerline-raw "%2c")
                                         (powerline-raw " | ")
                                         (powerline-raw "%6p")
                                         (powerline-raw " "))))
                         (concat (powerline-render lhs)
                                 (powerline-fill nil (powerline-width rhs))
                                 (powerline-render rhs)))))))

    (defun make/set-face (face-name fg-color bg-color weight)
      (make-face face-name)
      (set-face-attribute face-name nil
                          :foreground fg-color :background bg-color :box nil :weight weight))
    (make/set-face 'mode-line-1-fg "#282C34" "#EF8300" 'bold)
    (make/set-face 'mode-line-2-fg "#AAAAAA" "#2F343D" 'bold)
    (make/set-face 'mode-line-1-arrow  "#AAAAAA" "#3E4451" 'bold)
    (make/set-face 'mode-line-2-arrow  "#AAAAAA" "#3E4451" 'bold)

    (powerline-my-theme)))

;;; rainbow-delimiters
(use-package rainbow-delimiters
  :config
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
    (use-package cl-lib)
    (use-package color)
    (defun rainbow-delimiters-using-stronger-colors ()
      (interactive)
      (cl-loop
       for index from 1 to rainbow-delimiters-max-face-count
       do
       (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
         (cl-callf color-saturate-name (face-foreground face) 30))))
    (add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)))


;;; Language server protocol
(use-package lsp-mode
  :hook (ruby-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

;;; web-mode
(use-package web-mode
  :mode (("\\.html$" . web-mode)
         ("\\.vue$" . web-mode)
         ("\\.css$" . web-mode)
         ("\\.s?css$" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t)
  (setq web-mode-enable-css-colorization t))

;;; for sass
(use-package sass-mode
  :mode "\\.sass$")

;;; js2-mode
(use-package js2-mode
  :mode (("\\.js$" . js2-mode)
         ("\\.json$" . js2-mode))
  :config
  (setq my-js-mode-indent-num 2)
  (setq js2-basic-offset my-js-mode-indent-num)
  (setq js-switch-indent-offset my-js-mode-indent-num))

;; slime settings
;; necessary to execute 'ros install slime'
(load (expand-file-name "~/.roswell/helper.el"))

;; qlot
(defun slime-qlot-exec (directory)
  (interactive (list (read-directory-name "Project directory: ")))
  (slime-start :program "qlot"
               :program-args '("exec" "ros" "-S" "." "run")
               :directory directory
               :name 'qlot
               :env (list (concat "PATH=" (mapconcat 'identity exec-path ":")))))

;;; rbenv
(use-package rbenv :defer t
  :init
  (global-rbenv-mode))

;;; ruby-electric-mode
(use-package ruby-electric :defer t
  :init
  (add-hook 'ruby-mode-hook 'ruby-electric-mode))

;;; ruby-mode
(use-package ruby-mode :defer t
  :mode (("\\.rb$" . ruby-mode)
         ("\\.ruby$" . ruby-mode))
  :init
  (setq ruby-insert-encoding-magic-comment nil))

(use-package rspec-mode
  :defer 20
  :commands rspec-mode
  :config
  (add-hook 'ruby-mode-hook 'rspec-mode)
  ;; (rspec-install-snippets)
  :config
  (custom-set-variables '(rspec-use-rake-flag nil))
  (custom-set-faces))

;;; inf-ruby
(use-package inf-ruby :defer t
  :bind (("C-c i r b" . inf-ruby)))

;;; julia
(use-package ess :defer t :ensure t)

;;;; slim
(use-package slim-mode
  :ensure t
  :mode "¥¥.slim¥¥")

;;; docker
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package docker-compose-mode)


;; brew install multimarkdownが必要
(use-package markdown-mode
  :mode (("README\\.md$" . gfm-mode)
         ("\\.md$" . markdown-mode))
  :commands (markdown-mode gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;;; magit
(use-package magit)

;;; helm
(use-package helm :defer t
  :bind (("M-x" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c y"   . helm-show-kill-ring)
         ("C-c m"   . helm-man-woman)
         ("C-c o"   . helm-occur)
         :map helm-map
         ("C-h" . delete-backward-char)
         :map helm-find-files-map
         ("C-h" . delete-backward-char))
  :init
  (custom-set-faces
   '(helm-header           ((t (:background "#3a3a3a" :underline nil))))
   '(helm-source-header    ((t (:background "gray16" :foreground "gray64" :slant italic))))
   '(helm-candidate-number ((t (:foreground "#00afff"))))
   '(helm-selection        ((t (:background "#005f87" :weight normal))))
   '(helm-match            ((t (:foreground "darkolivegreen3")))))
  :config
  (helm-mode 1))

;;; helm-ag
(use-package helm-ag :defer t
  :init
  (setq helm-ag-base-command "rg --vimgrep --no-heading"))

(use-package symbol-overlay :defer t
  :bind (("M-i" . symbol-overlay-put)
         :map symbol-overlay-map
         ("p" . symbol-overlay-jump-prev)
         :map symbol-overlay-map
         ("n" . symbol-overlay-jump-next)
         :map symbol-overlay-map
         ("C-g" . symbol-overlay-remove-all))
  :config
  (add-hook 'prog-mode-hook 'symbol-overlay-mode))

;;; swiper
(use-package swiper-helm :defer t
  :bind (("C-s" . swiper)))

;;; projectile-rails
(use-package projectile-rails)

;;; projectile
(use-package helm-projectile
  :diminish projectile-mode
  :bind (("C-c p p" . helm-projectile-switch-project)
         ("C-c p g" . helm-projectile-grep)
         ("C-c r m" . projectile-rails-find-model)
         ("C-c r M" . projectile-rails-find-current-model)
         ("C-c r c" . projectile-rails-find-controller)
         ("C-c r C" . projectile-rails-find-current-controller)
         ("C-c r v" . projectile-rails-find-view)
         ("C-c r V" . projectile-rails-find-current-view)
         ("C-c r p" . projectile-rails-find-spec))
  :config
  (projectile-global-mode t)
  (helm-projectile-on)
  (projectile-rails-global-mode))

;;; haml mode
(use-package haml-mode :defer t)

;;; dumb-jump
(use-package dumb-jump :defer t
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window)
         ("M-g b" . dumb-jump-back))
  :config
  (setq dumb-jump-default-project "")
  (setq dumb-jump-selector 'helm)
  (setq dumb-jump-force-searcher 'rg))

;;; nginx-mode
(use-package nginx-mode)

;;; org
(use-package org :defer t
  :bind (("C-c a" . org-agenda)
         ("C-c b" . org-sitchb)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :config
  (setq org-directory "~/org")
  (setq org-default-notes-file "notes.org")
  (setq org-capture-templates
        '(("n" "Note" entry (file+headline "~/org/notes.org" "Notes")
           "* %?\nEntered on %U\n %i\n %a")
          ("m" "Minutes" entry (file+headline "~/org/minutes.org" "Minutes")
           "# %?\nEntered on %U\n"))))

;;; company
(use-package company
  :config
  (setq company-idle-delay 0)
  (set-face-attribute 'company-tooltip nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "steelblue")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "black" :background "steelblue")
  (set-face-attribute 'company-preview-common nil
                      :background nil :foreground "lightgrey" :underline t)
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "orange")
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "gray40")
  (global-set-key (kbd "C-M-i") 'company-complete)

  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)

  ;; C-sで絞り込む
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)

  ;; TABで候補を設定
  (define-key company-active-map (kbd "C-i") 'company-complete-selection)
  (define-key company-active-map [tab] 'company-complete-selection)

  ;; C-hの無効化
  (define-key company-active-map (kbd "C-h") nil)

  ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
  (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
  (global-company-mode 1))

(use-package undo-tree
  :config
  (global-undo-tree-mode t)
  (global-set-key (kbd "M-/") 'undo-tree-redo))

(use-package go-mode
  :mode (("\\.go$" . go-mode))
  :init
  (add-hook 'before-save-hook #'gofmt-before-save)
  :config
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq tab-width 4))

(use-package popwin)
(use-package eshell
  :bind (("C-x c" . eshell))
  :init
  (add-to-list 'popwin:special-display-config
             '("\\`\\*eshell" :regexp t :dedicated t :position bottom
               :height 0.3)))

(use-package instant-maximized-window
  :load-path "./modules/instant-maximized-window"
  :config
  (global-set-key (kbd "C-c C-o") 'window-temp-maximize))

(use-package awesome-tab
  :load-path "./modules/awesome-tab"
  :config
  (awesome-tab-mode t))

(use-package hydra
  :init
  (defun put-file-name-on-clipboard ()
    "Put the current file name on the clipboard"
    (interactive)
    (let ((filename (if (equal major-mode 'dired-mode)
                        default-directory
                      (buffer-file-name))))
      (when filename
        (with-temp-buffer
          (insert filename)
          (clipboard-kill-region (point-min) (point-max)))
        (message filename))))
  :config
  (defhydra awesome-fast-switch (global-map "C-q")
    "
 ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc                         ^^Window
-^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------+-^^---------------------------
   ^_k_^   prev group    | _C-a_^^     select first | _b_ search buffer | _C-k_   kill buffer          | _o_  toggle maximize window
 _h_   _l_  switch tab   | _C-e_^^     select last  | _g_ search group  | _C-S-k_ kill others in group | ^^
   ^_j_^   next group    | _C-j_^^     ace jump     | _f_ find file     | ^^                           | ^^
 _C-q_   toggle window | ^^                     | ^^                  | ^^                           | ^^
 ^^0 ~ 9^^ select window | _C-h_/_C-l_ move current | ^^                | ^^                           | ^^
-^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------+-^^---------------------------
"
    ("h" awesome-tab-backward-tab)
    ("j" awesome-tab-forward-group)
    ("k" awesome-tab-backward-group)
    ("l" awesome-tab-forward-tab)
    ("C-q" other-window)
    ("0" my-select-window)
    ("1" my-select-window)
    ("2" my-select-window)
    ("3" my-select-window)
    ("4" my-select-window)
    ("5" my-select-window)
    ("6" my-select-window)
    ("7" my-select-window)
    ("8" my-select-window)
    ("9" my-select-window)
    ("C-a" awesome-tab-select-beg-tab)
    ("C-e" awesome-tab-select-end-tab)
    ("C-j" awesome-tab-ace-jump)
    ("C-h" awesome-tab-move-current-tab-to-left)
    ("C-l" awesome-tab-move-current-tab-to-right)
    ("b" ivy-switch-buffer)
    ("g" awesome-tab-counsel-switch-group)
    ("C-k" kill-current-buffer)
    ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
    ("o" window-temp-maximize)
    ("f" (lambda ()
           (interactive)
           (helm-projectile-find-file)))
    ("q" t)
    ("C-g" nil "quit"))
  (defhydra quick-menu (global-map "<f1>")
    "
 ^^^^ Quick menu
-^^^^-----------------------
e^ Open ~/.emacs.d/init.el
z^ Open ~/.zshrc
n^ Open ~/notes directory
p^ Put current file name on clipboard
r^ Run command in project root
-^^^^-----------------------
"
    ("e" (lambda ()
           (interactive)
           (find-file "~/.emacs.d/init.el")))
    ("z" (lambda ()
           (interactive)
           (find-file "~/.zshrc")))
    ("n" (lambda ()
           (interactive)
           (find-file "~/notes/")))
    ("p" put-file-name-on-clipboard)
    ("r" projectile-run-shell-command-in-root)
    ("q" t)
    ("C-g" nil "quit")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-hl-line-mode t)
 '(package-selected-packages
   (quote
    (lsp-solargraph lsp-mode hydra rspec-mode golden-ratio popwin go-mode git-commit undo-tree ess ess-site shell-mode shell-script-mode flycheck helm-ag real-auto-save auto-save-buffers-enhanced auto-package-update use-package-ensure rbenv irb-ruby emacs-pry pry swiper-helm symbol-overlay ruby-electric projectile-rails nginx-mode scss-mode sass-mode haml-mode company helm-config helm magit neotree twittering-mode rainbow-delimiters jedi quelpa-use-package init-loader exec-path-from-shell diminish)))
 '(rspec-use-rake-when-possible nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-candidate-number ((t (:foreground "#00afff"))))
 '(helm-header ((t (:background "#3a3a3a" :underline nil))))
 '(helm-match ((t (:foreground "darkolivegreen3"))))
 '(helm-selection ((t (:background "#005f87" :weight normal))))
 '(helm-source-header ((t (:background "gray16" :foreground "gray64" :slant italic))))
 '(hl-line ((t (:inherit highlight :background "dark slate blue")))))
