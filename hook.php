<pre>
<?php
echo `
cd ../rulebook-latex 2>&1
git pull 2>&1
make 2>&1 | tee out/make.log
`;
?>
</pre>
