;; extends
(atx_heading (atx_h1_marker) (inline) @h1_content)
(atx_heading (atx_h2_marker) (inline) @h2_content)
(atx_heading (atx_h3_marker) (inline) @h3_content)
(atx_heading (atx_h4_marker) (inline) @h4_content)
(atx_heading (atx_h5_marker) (inline) @h5_content)
(atx_heading (atx_h6_marker) (inline) @h6_content)

(atx_heading (atx_h1_marker) @h1_marker)
(atx_heading (atx_h2_marker) @h2_marker)
(atx_heading (atx_h3_marker) @h3_marker)
(atx_heading (atx_h4_marker) @h4_marker)
(atx_heading (atx_h5_marker) @h5_marker)
(atx_heading (atx_h6_marker) @h6_marker)

(fenced_code_block (info_string) @code_block_info_string)

(list_item (task_list_marker_checked)) @list_item_done
