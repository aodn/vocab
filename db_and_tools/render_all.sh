output=skos_files15

rm -rf "$output"
mkdir "$output"

render() {
    local vocab=$1; shift

    echo "Rendering ${vocab}..."
    ./render.rb -t ${vocab}.erb $@        > $output/${vocab}.xml
    xmllint  --noout $output/${vocab}.xml
}

render AODNParameterVocabulary $@
render parameterClassificationScheme $@
render AODNPlatformVocabulary $@
render platformClassificationScheme $@

find -type f -size 0b -iname "*" -exec rm {} \;
rm $output.tgz
tar -czf $output.tgz $output
