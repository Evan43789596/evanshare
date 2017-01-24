package com.evanshare.controller;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.mvc.Mvcs;
import org.nutz.mvc.View;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Fail;
import org.nutz.mvc.annotation.Ok;
import org.nutz.mvc.annotation.Param;
import org.nutz.mvc.view.JspView;

import com.alibaba.druid.pool.DruidDataSource;

import net.sf.jsqlparser.JSQLParserException;
import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.statement.select.Select;
import net.sf.jsqlparser.util.TablesNamesFinder;

@IocBean
@Ok("json:{locked:'password|salt',ignoreNull:true}")
@Fail("http:500")
public class SqlController extends BaseModule{

    private final Logger logger = Logger.getLogger(SqlController.class);
    
    @At("/sql/sql_query")
    public View forwardToSqlQuery(){
        
        return new JspView("jsp/sql/sql_query");
    }
    
    @At("/sql/exportData")
    public void exportSqlData(@Param("querySql") String querySql,HttpServletResponse resp) throws FileNotFoundException, SQLException, IOException, JSQLParserException{
        exportExcelBySql(querySql,resp);
    }

    /**
     * 根据自定义sql导出报表
     * @param insql 自定义sql
     * @param resp 响应实体
     * @throws SQLException
     * @throws IOException
     * @throws FileNotFoundException
     * @throws JSQLParserException
     */
    private  void exportExcelBySql(String insql,HttpServletResponse resp)
            throws SQLException, IOException, FileNotFoundException, JSQLParserException {
        // 11:创建一个excel
        SXSSFWorkbook book = new SXSSFWorkbook(1000);
        java.sql.ResultSet rs = null;
       List<String> tables =  getTables(insql);
       DataSource datasource =  Mvcs.getIoc().get(DruidDataSource.class, "dataSource");
        Connection conn = null;
        Statement st =null;
        try {
            conn = datasource.getConnection();
            // 3:声明st
            double maxRowNum;
            int sheets;
            ResultSetMetaData rsmd;
            int cols;
            long startTime;
            long endTime;
            st = conn.createStatement();

            //结果集总行数
            double totalcount = 137713;

            /* excel单表最大行数是65535 */
            maxRowNum = 60000;

            sheets = (int) Math.ceil(totalcount / maxRowNum);
            rs = st.executeQuery(insql);
            // 3:rsmd
            rsmd = (ResultSetMetaData) rs.getMetaData();
            // 4:分析一共多少列
            cols = rsmd.getColumnCount();
            startTime = System.currentTimeMillis();

            //写入excel文件数据信息
            for (int i = 0; i < sheets; i++) {
                logger.info("<=======正在导出报表=========>");

                // 12:创建sheet
                SXSSFSheet sheet = book.createSheet(" " + (i + 1) + " ");

                // 13:创建表头
                SXSSFRow row = sheet.createRow(0);

                for (int j = 0; j < cols; j++) {
                    String cname = rsmd.getColumnName(j + 1);

                    SXSSFCell cell = row.createCell(j);
                    cell.setCellValue(cname);

                }
                // 显示数据
                for (int t = 0; t < maxRowNum; t++) {
                    if (!rs.next()) {
                        break;
                    }
                    // 14：保存数据
                    row = sheet.createRow(sheet.getLastRowNum() + 1);

                    for (int j = 0; j < cols; j++) {
                        SXSSFCell cell = row.createCell(j);
                        cell.setCellValue(rs.getString(j + 1));
                    }
                }
           
           
         /*   while (rs.next()) {
                // 14：保存数据
                row = sheet.createRow(sheet.getLastRowNum() + 1);

                for (int j = 0; j < cols; j++) {
                    SXSSFCell cell = row.createCell(j);
                    cell.setCellValue(rs.getString(j + 1));

                }
            }*/
            }

            resp.reset();
            resp.setContentType("multipart/form-data"); //自动识别
            resp.setHeader("Content-Disposition", "attachment;filename=data.xls");
            book.write(resp.getOutputStream());
            endTime = System.currentTimeMillis();
            logger.info("导出报表所用时间为:" + (endTime - startTime));
        }catch (Exception ex){
            logger.info(String.format("导出报表异常,Sql=【%s】,异常信息{}",insql),ex);

        }finally {
            if(book!=null){
                book.close();
            }
            if(rs!=null){
                rs.close();
            }
            if(st!=null){
                st.close();
            }
            if(conn!=null){
                conn.close();
            }
        }
    }

    /**
     * 获取对应的表
     * @param insql 自定义sql
     * @return
     * @throws JSQLParserException
     */
    private  List<String> getTables(String insql) throws JSQLParserException{
        net.sf.jsqlparser.statement.Statement statement = CCJSqlParserUtil.parse(insql);
        Select selectStatement = (Select)statement;
        TablesNamesFinder tablesNamesFinder = new TablesNamesFinder();
        List<String> result = tablesNamesFinder.getTableList(selectStatement);
        return result;
    }

}
