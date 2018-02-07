(defconst word-list-path
  "./bestwords.txt"
  "The file-system path containing the word list.")

(defconst regexp-path
  "./bestwords.regexp"
  "The file-system path containing the regular expression.")

(defconst whitespace-chars
  " \t\r\v"
  "Whitespace control sequences.")

(defun change-start-case (word upcase-p)
  "Change the case of the first letter of WORD.
If UPCASE-P is non-nil, make it uppercase; otherwise, make it
lowercase."
  (concat (funcall (if upcase-p #'upcase #'downcase)
                   (substring word 0 1))
          (substring word 1)))


(defun parse-items ()
  "In the current buffer, read each line as an item.
Whitespace defined by `whitespace' is stripped off of the front
and end of each item."
  (let (words)
    (while (char-after)
      (let* ((bol        (point-at-bol))
             (eol        (point-at-eol))
             (item-start (progn (skip-chars-forward whitespace-chars eol)
                                (point)))
             (item-end   (progn (goto-char (point-at-eol))
                                (skip-chars-backward whitespace-chars eol)
                                (point))))
        (let ((word (buffer-substring item-start item-end)))
          (push (change-start-case word nil) words)
          (push (change-start-case word t)   words))
        (forward-line 1)))
    words))

(defun read-word-list ()
  "Read the word list out of `word-list-path'."
  (with-temp-buffer
    (insert-file-contents-literally word-list-path)
    (goto-char (point-min))
    (parse-items)))

(defun write-regexp (word-list)
  "Writes a matching regular expression to `regexp-path'.
Each item in WORD-LIST is fed into `regexp-opt' to generate the
regular expression.  The regular expression will be surrounded
with the \\b escape code."
  (with-temp-buffer
    (insert (regexp-opt word-list t))
    ;; replace extraneous escapes and wrap with \\b
    (goto-char (point-min))
    (insert "\\b")
    (let ((continue t))
      (while continue
        (setq continue nil)
        (when (search-forward-regexp "\\\\\\([()|]\\)" nil t)
          (setq continue t)
          (replace-match "\\1" t))
        (when (search-forward "’" nil t)
          (setq continue t)
          (replace-match "'" t))))
    (goto-char (point-max))
    (insert "\\b\n")
    (write-file regexp-path)))

(defun main ()
  "Run as `emacs --batch --quick --load regexp.el --funcall main'."
  (write-regexp (read-word-list)))
