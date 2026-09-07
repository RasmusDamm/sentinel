name="Ib"
echo "Hej, $name"
echo 'Hej, $name'

files=$(ls /etc | wc -l)
echo "Der er $files filer"

if [[ -f /etc/passwd ]]; then
    lines=$(wc -l < /etc/passwd)
    echo "passwd har $lines linjer"
    exit 0
else
    echo "findes ikke" >&2
    exit 1
fi
    