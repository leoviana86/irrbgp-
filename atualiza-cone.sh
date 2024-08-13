#!/bin/bash

# Arquivo de saída
output_file="arquivo-02"

# Limpa o arquivo de saída se já existir
> "$output_file"

# Adiciona "configure;" no início do arquivo
echo "configure;" >> "$output_file"

# Função para processar AS-SETs para IPv4
process_as_set_ipv4() {
    local as_set=$1
    local policy_statement=$2
    bgpq4 -AJEl eltel -R 8 -R 24 "$as_set" | \
    awk -v ps="$policy_statement" '{print "set policy-options policy-statement " ps " term 1 from",$1,$2,$3,$4}' | \
    grep route-filter | \
    sed 's/;//g' | \
    sed 's/$/;/' >> "$output_file"
    # Adiciona uma linha em branco
    echo "" >> "$output_file"
}

# Função para processar AS-SETs para IPv6
process_as_set_ipv6() {
    local as_set=$1
    local policy_statement=$2
    bgpq4 -6AJEl eltel -R 8 -R 24 "$as_set" | \
    awk -v ps="$policy_statement" '{print "set policy-options policy-statement " ps " term 2 from",$1,$2,$3,$4}' | \
    grep route-filter | \
    sed 's/;//g' | \
    sed 's/$/;/' >> "$output_file"
    # Adiciona uma linha em branco
    echo "" >> "$output_file"
}

# Processamento de AS-SETs para IPv4
process_as_set_ipv4 "AS-NIC-BR" "Policy-teste-v4"

process_as_set_ipv6 "AS-NIC-BR" "Policy-teste-v6"
# Adiciona "commit;" no final do arquivo
echo "commit;" >> "$output_file"
