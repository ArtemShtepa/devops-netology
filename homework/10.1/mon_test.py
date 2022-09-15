#!/usr/bin/env python3
import os
import datetime
import json
import subprocess


PROC_PATH = "/proc"
LOG_PATH = "/home/sa/10.1/"
LOG_FILE = "-awesome-monitoring.log"

# Получение списка PID
def pid_list():
    res = []
    for s in os.listdir(PROC_PATH):
        if os.path.isdir(f"{PROC_PATH}/{s}") and s.isdigit():
            res.append(int(s))
    return res;

# Получение списка открытых портов
def port_list():
    res = []
    cmd = subprocess.run(["ss", "-antu", "-H"], capture_output=True, text=True)
    for raw_line in cmd.stdout.splitlines():
        raw_list = (" ".join(raw_line.split())).split()
        raw_dict = dict()
        raw_dict['type'] = raw_list[0]
        raw_dict['state'] = raw_list[1]
        raw_dict['local'] = raw_list[4]
        raw_dict['peer'] = raw_list[5]
        res.append(raw_dict)
    return res

# Вспомогательная функция чтения однострочного файла и разбивки строки на список
def parse_oneline_file(file_name):
    with open(f"{PROC_PATH}/{file_name}", "r") as f:
        return f.read().replace("\n", "").split(" ")

# Интерпретация файла loadavg - средняя загрузка ЦПУ
def load_avg():
    raw = parse_oneline_file("loadavg")
    return dict(load_now=raw[0], load_5m=raw[1], load_15m=raw[2], threads=raw[3])

# Интерпретация файла uptime - время работы
def uptime():
    raw = parse_oneline_file("uptime")
    return dict(up_time=raw[0], idle_time=raw[1])

# Формирование строки лога
log = dict()
log['timestamp'] = int(datetime.datetime.now().timestamp())
log['pid_list'] = pid_list()
log['ports'] = port_list()
log['loadavg'] = load_avg()
log['uptime'] = uptime()
# Формирование метки даты для имени файла
file_date = datetime.datetime.now().strftime("%y-%m-%d")
# Сохранение строки лога в файл
with open(f"{LOG_PATH}{file_date}{LOG_FILE}", "a") as f:
    f.write(json.dumps(log)+"\n")
