# talos-elk-blocklist-query

This is a scirpt to query an elasticsearch filebreat index and look for IPs from a list provided. I built it to work with the talos block list that can be downloaded here: https://talosintelligence.com/documents/ip-blacklist. It could really use any list of IP Addresses (one per line) from a .txt file as an input. Any of the IPs found will be saved to another txt file as well as being output to console while being run. IPs that are found can be investigated accordingly or added to a block list in your firewall if you prefer.

# Elasticsearch Host
You will need to substitute localhost with your elasticsearch server. Also, if you require authentication to access elasticsearch, you will need to provide credentials accordingly for the environment where you will be running it. 
