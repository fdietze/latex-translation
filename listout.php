<script language="javascript">
function update() {
  var xhr = new XMLHttpRequest(), self = this;
  xhr.open('GET', '../rulebook-latex-scripts/hook.php', true);
  xhr.onload = function (e) {
	  if (xhr.readyState === 4) {
		  location.reload();
	  }
  };
  xhr.send();
}
</script>

<?php

$show = '/((\.tex|make)\.log$)|(^.+\.pdf$)/';
echo "<table border=1>";
echo "<tr><th>filename</th><th>modified</th><th>size</th></tr>";
$dir = "../../rulebook-latex/out";
$files = scandir($dir);
sort($files);
foreach ( $files as $file ) {
   if( preg_match($show,$file) ) {
     echo "<tr><td><a href=\"../rulebook-latex-out/$file\">$file</a></td>".
     "<td>".date("F d Y H:i:s", filemtime($dir."/".$file))."</td>".
     "<td align=\"right\">".intval(filesize($dir."/".$file)/1024)."k</td></tr>\n";
   }
}
echo "</table>";

?>

<br />
<input type="button" value="update" onClick="update();this.value = 'working...';this.disabled=true;" />

<?php
echo "<pre>\n\nlast commits:\n\n";
echo `cd ../../rulebook-latex; git log -n 10 --pretty=full --pretty=format:"%ar: %an\n%B\n" --graph --stat`."</pre>";
?>
