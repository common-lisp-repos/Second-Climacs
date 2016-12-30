(cl:in-package #:climacs-esa-gui)

;;; This class is is a subclass of CLIMACS-CLIM-VIEW.  An instance of
;;; this class is created in order to display a Climacs view that is
;;; an instance of CLIMACS2-BASE:FUNDAMENTAL-VIEW.

(defclass fundamental-view (climacs-clim-view) ())

(defmethod climacs-clim-view-class ((view climacs2-base:fundamental-view))
  (find-class 'fundamental-view))

(defmethod command-table ((view  climacs2-base:fundamental-view))
  'global-climacs-table)

;;; Since the FUNDAMENTAL-VIEW contains a NULL-ANALYZER, the method on
;;; UPDATE-VIEW-FROM-ANALYZER specialized to the NULL-ANALYZER calls
;;; UPDATE-VIEW-FROM-ANALYZER recursively with the buffer replacing
;;; the analyzer.  That is why the following method is specialized to
;;; the STANDARD-BUFFER, and not to a subclass of ANALYZER.

(defmethod climacs2-base:update-view-from-analyzer
    ((view climacs2-base:fundamental-view)
     (pane text-pane)
     (buffer climacs2-base:standard-buffer))
  (let* ((index 0)
	 (climacs-clim-view (clim:stream-default-view pane))
	 (lines (lines climacs-clim-view))
	 (history (clim:stream-output-history pane)))
    (flet ((delete-line (index)
	     (flexichain:delete* lines index)
	     (climacs-flexichain-output-history:delete history index)))
      (flet ((delete-lines-until-line (line)
	       (loop for entry = (flexichain:element* lines index)
		     until (eq line (car entry))
		     do (delete-line index))))
	(flet ((skip (n)
		 (incf index n))
	       (modify (line)
		 (delete-lines-until-line line)
		 (let ((entry (flexichain:element* lines index)))
		   (setf (cdr entry)
			 (cluffer:items (car entry)))
		   (climacs-flexichain-output-history:replace
		    history
		    (clim:with-output-to-output-record (pane)
		      (format pane "~a" (coerce (cdr entry) 'string)))
		    index))
		 (incf index))
	       (sync (line)
		 (delete-lines-until-line line)
		 (incf index))
	       (create (line)
		 (let ((entry (cons line (cluffer:items line))))
		   (flexichain:insert* lines index entry)
		   (climacs-flexichain-output-history:insert
		    history
		    (clim:with-output-to-output-record (pane)
		      (format pane "~a" (coerce (cdr entry) 'string)))
		    index))
		 (incf index)))
	  (setf (timestamp climacs-clim-view)
		(cluffer:update (climacs2-base:cluffer-buffer buffer)
				(timestamp climacs-clim-view)
				#'sync #'skip #'modify #'create)))))))
