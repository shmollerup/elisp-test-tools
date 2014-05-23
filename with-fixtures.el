(defun with-fixtures-setup (fixtures body)
  "Recursive inner function for with-fixtures function.
   Sets up each fixture in FIXTURES and creates inner lambda
   function for each with the appropriate parameters."
  (if (not (= 0 (length fixtures)))

      (let ((fixture (pop fixtures)))

        `(,(nth 0  (nth (- (length fixture) 1) fixture))
          (lambda ,(reverse (cdr (reverse fixture)))
            ,(with-fixtures-setup fixtures body))
          ,@(cdr (nth (- (length fixture) 1) fixture))))

    body))

(defmacro with-fixtures* (fixtures body)
  "Sets up FIXTURES then eval BODY.
   Sets up each fixture and bind variables accordingly.
   Each element of FIXTURES is a list (VARIABLE (FIXTURE FIXTURE-ARGS)),
   where VARIABLE and FIXTURE-ARGS can be nil.

   Example of usage:

   (defun my-fixture (body arg-1 arg-2)
     (unwind-protect
         (funcall body arg-1 arg-2)
       ()))

   (with-fixtures* ((f1 f2 (my-fixture \"ARG-1\" \"ARG-2\"))
                    (f3 f4 (my-fixture f1 \"ARG-3\")))

     ;; body
     (message \"args %s %s\" f3 f4))"

  (with-fixtures-setup fixtures body))

(put 'with-fixtures* 'lisp-indent-function 1)

(provide 'with-fixtures)



