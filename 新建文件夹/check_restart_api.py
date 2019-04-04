#!/usr/bin/env python
import re,subprocess
LOG_FILE = "/data/weblogs/api/catalina.out"
ERROR_LOG = "/tmp/api_error.log"
ERROR_PAT = r'ERROR\s+-\s+abandon\s+connection'
RESTART_CMD = "/home/ecloud/bin/api/restartApi.sh"

class check:
    def __init__(self, pos, file):
        self.pos = pos or 0
        self.fobj = open(file, 'r')

    def do(self):
        self.fobj.read(self.pos)
        for line in self.fobj:
            if re.search(ERROR_PAT, line):
                print(line)
                subprocess.call(RESTART_CMD, shell=True)
                self.pos = self.fobj.tell()

if __name__ == "__main__":
    mo = check(LOG_FILE)
    mo.do()
