<%@ page language="java" pageEncoding="UTF-8" %>
<%
    //    response.setHeader("Pragma", "No-cache");
//    response.setHeader("Cache-Control", "no-cache");
//    response.setDateHeader("Expires", 0);
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    String time = System.currentTimeMillis() + "";
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title></title>
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<script src="js/angular1.5.0.min.js"></script>
<style>
   *{font-size: 14px;font-weight: inherit}
</style>
<body ng-app="myApp">



<div ng-controller="shopController">

        <form class="form-horizontal">
        <div class="form-group">

            <label  class="col-sm-2 control-label">日期</label>
            <div class="col-sm-2">
                <input type="text" ng-model="date" class=" form-control" value="2016-02-01"/>
            </div>
            <label  class="col-sm-2 control-label">起：</label>
            <div class="col-sm-2">
                <input type="text" ng-model="start" value="SHH" class="form-control"/>
            </div>
            <label  class="col-sm-2 control-label">终：</label>
            <div class="col-sm-2">
                <input type="text" ng-model="end" value="CDW" class=" form-control"/>
            </div>


        </div>

        <div  class="form-group">
            <label class="col-sm-2 control-label">过滤车次：</label>
            <div class="col-sm-2">
                <input ng-model="code" type="text" class="form-control"/>
            </div>
            <label class="col-sm-2" >车次：</label>
            <div class="col-sm-2">
                D:<input type="checkbox" ng-model="D" type="text" />&nbsp;K:<input type="checkbox" ng-model="K" type="text"/>
                </div>
            <label  class="col-sm-2">查询次数：</label>
            <div class="col-sm-2">
            <span style="color: red">{{num}}</span>
            </div>
        </div>

    <br/>
        <div  class="form-group text-center">
            <div >
                <button ng-click="queryClick()" class="btn btn-info" style="width: 80px">查询</button>
                <label >循环：</label><input ng-model="isFor" type="checkbox"/>
            </div>
        </div>

        <p style="display: none">
            <video id="music" src="js/music1.mp3" loop="loop"></video></p>
   </form>

    <div style="width: 100%;height:auto;font-size:30px;font-weight: bold;color:red;text-align: center;padding:10px 0px" >
        {{msg}}
    </div>
    <div class="table-responsive">
    <table width="90%" class="table table-hover">
        <tr>
            <th width="49" rowspan="1" colspan="1">车次</th>
            <th width="100" rowspan="1" colspan="1">日期</th>
            <th width="100" rowspan="1" colspan="1">发车站</th>
            <th width="100" rowspan="1" colspan="1">终点站</th>

            <th width="49" rowspan="1" colspan="1">一等座</th>
            <th width="49" rowspan="1" colspan="1">二等座</th>
            <th width="49" rowspan="1" colspan="1">硬卧</th>
            <th width="49" rowspan="1" colspan="1">硬座</th>

        </tr>
        <tr ng-repeat="data in datas | filter:{station_train_code:code}"  >
            <th width="49" rowspan="1" colspan="1">{{data.station_train_code }}</th>
            <th width="100" rowspan="1" colspan="1">{{data.start_train_date }}</th>
            <th width="100" rowspan="1" colspan="1">{{data.start_station_name }}</th>
            <th width="100" rowspan="1" colspan="1">{{data.end_station_name }}</th>

            <th width="49" rowspan="1" colspan="1">{{data.zy_num}}</th>
            <th width="49" rowspan="1" colspan="1"><span style="color: red">{{data.ze_num}}</span></th>
            <th width="49" rowspan="1" colspan="1">{{data.yw_num}}</th>
            <th width="49" rowspan="1" colspan="1">{{data.yz_num}}</th>

        </tr>

    </table>
</div>

</div>

<script>
    var myApp = angular.module("myApp", []);


    myApp.controller("shopController",function($scope,$http){
        $scope.datas=[];
        $scope.date="2016-02-01";
        $scope.start="SHH";
        $scope.end="CDW";
        $scope.time=5;
        $scope.num=0;
        $scope.isFor=false;
        $scope.D=true;
        $scope.K=true;
        $scope.msg="";

        $scope.queryClick=function(){
            $scope.num=0;
            query($scope,$http)
        };

        var timer=window.setInterval(function(){
        if( $scope.isFor==true){
            query($scope,$http)
        }

        },5000);
    });

    function query($scope,$http){
        var myVideo = document.getElementsByTagName('video')[0];
        myVideo.pause();
        $scope.num++;
        $scope.datas=[];
        $scope.msg="";
        $http({
            method: 'GET',
            url: 'query',
            params: {
                'date': $scope.date,
                'D': $scope.D,
                'K': $scope.K,
                'start': $scope.start,
                'end': $scope.end
            }
        }).success(function(data,status,headers,config) {
// 当相应准备就绪时调用
            $scope.datas=data.data.datas
            if(data.state){
               $scope.isFor=false;
                $scope.msg="找到票了，速度抢啊！";


                if (myVideo.paused){
                    myVideo.play();
                }
            }

        }).error(function(data,status,headers,config) {
// 当响应以错误状态返回时调用
        });

    }


</script>
</body>
</html>