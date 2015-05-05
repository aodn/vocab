set -x
output=skos_files15

rm -rf "$output/*"
mkdir "$output"


./render.rb -t AODNParameterVocabulary.erb $@        > $output/AODNParameterVocabulary.xml
./render.rb -t parameterClassificationScheme.erb $@  > $output/parameterClassificationScheme.xml


./render.rb -t AODNPlatformVocabulary.erb $@         > $output/AODNPlatformVocabulary.xml
./render.rb -t platformClassificationScheme.erb $@   > $output/platformClassificationScheme.xml

find -type f -size 0b -iname "*" -exec rm {} \;

xmllint  --noout $output/AODNParameterVocabulary.xml
xmllint  --noout $output/parameterClassificationScheme.xml 
xmllint  --noout $output/AODNPlatformVocabulary.xml
xmllint  --noout $output/platformClassificationScheme.xml


rm $output.tgz
tar -czf $output.tgz $output
