import requests
import time
def test():
    # 從 node_list_all 檔案中取得第一個 IP 作為 prom_host
    with open("node_list_all", "r") as node_file:
        lines = node_file.read().splitlines()
        prom_host = lines[0].strip() if lines else "127.0.0.1"  # 若檔案沒有內容，就預設為127.0.0.1

    prom_port = 30090
    prom_url = f"http://{prom_host}:{prom_port}/api/v1/targets"
    prom_header = {'Accept-Encoding': 'gzip'}

    r = requests.get(url=prom_url, headers=prom_header)
    data = r.json()

    # 將寫入檔案行為包裝在 with 區塊裡確保安全關閉
    with open("prom_scrape_rntsm", 'a') as f:
        for item in data["data"]["activeTargets"]:
            if item["labels"].get("job") == "rntsm":
                print(item["scrapeUrl"])
                f.write(str(item["lastScrapeDuration"]))
                f.write("\n")

i = 0
while i < 1200:
    test()
    time.sleep(1)
    i += 1