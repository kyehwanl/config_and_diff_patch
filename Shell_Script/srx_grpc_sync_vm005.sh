#!/bin/sh -x

echo "srx gprc sync with github..."
cp -rf /opt/project/gobgp_test/gowork/src/srx_grpc /tmp/
cd /tmp/srx_grpc
git remote add github_repo https://github.com/kyehwanl/srx_grpc.git
~/Emulab/Shell_Script/input-expect-github_repo.sh
rm -rf /tmp/srx_grpc
echo "Done"


