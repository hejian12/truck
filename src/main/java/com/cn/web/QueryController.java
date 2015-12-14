package com.cn.web;


import com.cn.utils.HttpsUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by hejian on 2015/12/8 0008.
 */
public class QueryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req,resp);
    }

    /**
     * 查询111
     * @param req
     * @param resp
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String date=req.getParameter("date");
        String start=req.getParameter("start");
        String end=req.getParameter("end");
        String D=req.getParameter("D");
        String K=req.getParameter("K");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("content-type","text/html;charset=UTF-8");
        PrintWriter write=resp.getWriter();
        try {
            String url="https://kyfw.12306.cn/otn/lcxxcx/query?purpose_codes=ADULT&queryDate="+date+"&from_station="+start+"&to_station="+end+"";
            String result= HttpsUtils.httpRequest(url,"GET",null);

            System.out.println(result);
            int state=has(result,D,K);
            if (state==1){
                JSONObject object=JSONObject.fromObject(result);
                object.put("state","OK");
                result=object.toString();
                //.toString();
            }
            write.print(result);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            write.flush();
            write.close();
        }
    }



    private int has(String data,String D,String K){
        JSONObject object=JSONObject.fromObject(data);
        if(object.getInt("httpstatus")==200){
            if(object.has("data")){
                JSONObject dataObject=object.getJSONObject("data");
                if (dataObject.has("datas")){
                    JSONArray datas=dataObject.getJSONArray("datas");
                    if(datas.size()>0){
                        int result=0;
                        for (int i = 0; i <datas.size() ; i++) {
                            JSONObject train= (JSONObject) datas.get(i);
                            String ze_numStr=train.getString("ze_num");
                            String yz_numStr=train.getString("yz_num");
                            String yw_numStr=train.getString("yw_num");

                            int ze_num=0;
                            int yz_num=0;
                            int yw_num=0;

                                if(ze_numStr.indexOf("-")>-1 || ze_numStr.indexOf("无")>-1 || ze_numStr.indexOf("*")>-1){
                                    ze_num=0;
                                }else{
                                    ze_num=Integer.parseInt(ze_numStr);
                                }
                                if(yz_numStr.indexOf("-")>-1 || yz_numStr.indexOf("无")>-1 || yz_numStr.indexOf("*")>-1){
                                    yz_num=0;
                                }else{
                                    yz_num=Integer.parseInt(yz_numStr);
                                }
                                if(yw_numStr.indexOf("-")>-1 || yw_numStr.indexOf("无")>-1 || yw_numStr.indexOf("*")>-1){
                                    yw_num=0;
                                }else{
                                    yw_num=Integer.parseInt(yw_numStr);
                                }



                                String station_train_code=train.getString("station_train_code");
                                if ( D.equals("true")&& (station_train_code.indexOf("D")>-1) && ze_num>0){
                                    result=1;
                                    break;
                                }
                                if (K.equals("true")&& (station_train_code.indexOf("K")>-1) && (yz_num>0  || yw_num>0)){
                                    result=1;
                                    break;
                                }


                        }
                        return result;
                    }
                }
            }

        }else{
            return 400;
        }

        return 0;
    }
}
