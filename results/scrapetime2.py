import requests
import time
def test():
    prom_host="10.158.0.2"
    f = open("prom_scrape_rntsm", 'a')
    prom_port = 30090
    prom_url = "http://" + str(prom_host) + ":" + \
                                str(prom_port) + "/api/v1/targets"
    prom_header = {'Accept-Encoding': 'gzip'}
    r = requests.get(url=prom_url,headers=prom_header)
    data = r.json()
    for item in data["data"]["activeTargets"]:
        if item["labels"]["job"] == "cluster1":
            print(item["scrapeUrl"])
            f.write(str(item["lastScrapeDuration"]))
            f.write("\n")
            f.close
i=0
while i<1200:
    test()
    time.sleep(1)
    i+=1