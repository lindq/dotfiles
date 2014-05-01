;;; .emacs --- david's emacs init file

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "david")
(setq initial-scratch-message nil)

(setq ispell-program-name "aspell")
(setq Man-notify-method 'bully)
(setq truncate-partial-width-windows 100)
(setq js-indent-level 2)

(column-number-mode 1)
(delete-selection-mode 1)
(global-font-lock-mode 1)
(menu-bar-mode -1)
(show-paren-mode 1)
(transient-mark-mode 1)

(prefer-coding-system 'utf-8)
(fset 'yes-or-no-p 'y-or-n-p)

(if (not (boundp 'user-emacs-directory))
    (setq user-emacs-directory "~/.emacs.d/"))

(let ((backup-directory (concat user-emacs-directory "backups")))
  (setq backup-directory-alist (list (cons "." backup-directory))))

(let ((elisp-directory (concat user-emacs-directory "elisp")))
  (setq load-path (cons elisp-directory load-path)))

(cond ((eq system-type 'darwin)
       (setq pbcopy-command "/usr/bin/pbcopy")
       (setq pbpaste-command "/usr/bin/pbpaste"))
      ((eq system-type 'gnu/linux)
       (setq pbcopy-command "/usr/bin/xsel --clipboard --input")
       (setq pbpaste-command "/usr/bin/xsel --clipboard --output")))

;; Add the buffer file's directory path to the mode line.
(add-to-list
 'global-mode-string
 '(:eval
   (and (buffer-file-name)
        (let* ((dir (file-name-directory (buffer-file-name)))
               (re (concat "^" (getenv "HOME")))
               (path (replace-regexp-in-string re "~" dir)))
          (concat " " path " ")))
   ))

;;; global key bindings

(global-set-key (kbd "C-a") 'my-beginning-of-line)
(global-set-key (kbd "C-<left>") 'my-beginning-of-line)
(global-set-key (kbd "M-[ D") 'my-beginning-of-line)
(global-set-key (kbd "C-<right>") 'my-end-of-line)
(global-set-key (kbd "M-[ C") 'my-end-of-line)
(global-set-key (kbd "C-<up>") 'previous-line)
(global-set-key (kbd "M-[ A") 'previous-line)
(global-set-key (kbd "C-<down>") 'next-line)
(global-set-key (kbd "M-[ B") 'next-line)
(global-set-key (kbd "ESC <down>") 'scroll-up-1-line)
(global-set-key (kbd "M-<down>") 'scroll-up-1-line)
(global-set-key (kbd "ESC <up>") 'scroll-down-1-line)
(global-set-key (kbd "M-<up>") 'scroll-down-1-line)
(global-set-key (kbd "C-f") 'forward-word)
(global-set-key (kbd "C-b") 'backward-word)
(global-set-key (kbd "C-c >") 'indent-lines-in-region)
(global-set-key (kbd "C-c w") 'pbcopy)
(global-set-key (kbd "C-c y") 'pbpaste)
(global-set-key (kbd "C-x C-b") 'bs-show)
(global-set-key (kbd "C-/") 'undo)

;;; general functions

(defun scroll-up-1-line ()
  (interactive)
  (if (< (window-end) (point-max))
      (scroll-up 1))
  (forward-line 1))

(defun scroll-down-1-line ()
  (interactive)
  (if (> (window-start) 1)
      (scroll-down 1))
  (forward-line -1))

(defun indent-lines-in-region (start end)
  (interactive "r")
  (apply-macro-to-region-lines start end "\t")
  (deactivate-mark))

(defun my-beginning-of-line ()
  (interactive)
  (let ((p (point)))
    (beginning-of-line-text)
    (if (and (<= p (point))
             (> p (line-beginning-position)))
        (beginning-of-line))))

(defun my-end-of-line ()
  (interactive)
  (end-of-line))

(defun pbcopy (start end)
  (interactive "r")
  (shell-command-on-region start end pbcopy-command)
  (let ((buf (get-buffer "*Shell Command Output*")))
    (if (buffer-live-p buf)
        (kill-buffer buf)))
  (deactivate-mark))

(defun pbpaste ()
  (interactive)
  (insert (shell-command-to-string pbpaste-command)))

;;; tabs and trailing whitespace

(setq-default indent-tabs-mode nil)
(setq untabify-mode-list '(css emacs-lisp javascript js python))

(defun untabify-buffer ()
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max)))
    ))

(dolist (mode untabify-mode-list)
  (let ((hook (intern (concat (prin1-to-string mode) "-mode-hook"))))
    (add-hook hook
              (lambda ()
                (set (make-local-variable 'require-final-newline) t)
                (set (make-local-variable 'show-trailing-whitespace) t)
                (make-local-variable 'write-contents-functions)
                (add-hook 'write-contents-functions 'untabify-buffer)
                (add-hook 'write-contents-functions 'delete-trailing-whitespace))
              )))

;;; Dired mode

(setq dired-omit-size-limit nil)

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ))

(add-hook 'dired-mode-hook
          (lambda ()
            (dired-omit-mode 1)
            (local-set-key "K" 'my-dired-omit-expunge)
            ))

(defun my-dired-omit-expunge ()
  "Builds a regexp to pass to `dired-omit-expunge' based on the values
in `dired-omit-extensions'. Helpful for Dired listings resulting from
running `find-grep-dired', which doesn't run omit after completion."
  (interactive)
  (let (result regexp)
    (dolist (ext dired-omit-extensions)
      (if (eq ?. (aref ext 0))
          (setq ext (concat "\\" ext)))
      (if (eq ?/ (aref ext (1- (length ext))))
          (setq ext (concat "\\(^\\|.*/\\)" ext ".*")))
      (setq ext (concat ext "$"))
      (setq result (cons ext result)))
    (setq regexp (mapconcat 'identity result "\\|"))
    (dired-omit-expunge regexp)))

(require 'package)
(package-initialize)

;;; .emacs ends here
