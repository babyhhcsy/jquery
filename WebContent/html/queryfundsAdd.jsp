<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="/common/taglibs.jsp"%>
<%@include file="/common/common.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<script src="${ctx }/static/js/uploadify/lang.js"></script>
<!-- 系统公共JS方法 -->
<style type="text/css">
.form-group {
	float: left;
	margin-left: 30px;
}

.form-group-list {
	float: left;
	clear: both;
	margin-top: 5px;
	margin-left: 30px;
}

.from-group-label {
	margin-right: 40px;
	width: 150px;
}
</style>
</head>
<link rel="stylesheet" href="${ctx }/common/xheditor/xhEditor_skin/default/ui.css">
<link rel="stylesheet" href="${ctx }/common/xheditor/xhEditor_skin/default/iframe.css">
<script type="text/javascript" src="${ctx }/common/xhEditor/jquery/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${ctx }/common/xhEditor/xheditor-1.1.14-zh-cn.min.js"></script>
<script type="text/javascript" src="${ctx }/static/js/layer-v1.8.5/layer/layer.min.js"></script>
<script src="${ctx }/static/js/ajaxfileupload.js"></script>
<%-- <script type="text/javascript" src="${ctx }/static/js/JSFrameWork.js"></script> --%>
<script type="text/javascript">
	$(function(){
		$(pageInit);
		function pageInit() {
			$("#safeguards").xheditor({tools:'full'});
			
		}
	});
	// 保存
	function save() {
		var bo = validationEngine();
		var errorTextArr = ["基金项目名称不能为空","募集金额不能为空且只能为数字","年化收益不能为空","回款方式不能为空","期限不能为空","法律形式不能为空","基金总规模不能为空","基金存续时间不能为空","基金团队不能为空","合作伙伴不能为空","用款企业不能为空","托管银行不能为空","担保公司不能为空","认缴基金不能为空","基金类别不能为空","预期收益不能为空","基金用途不能为空","还款来源不能为空"];
		beforeSubmit();
		if(null==bo){
			$("#mgFrm")[0].submit();
		}else{
			var index = bo.index;
			var errorText = "";
			for(var i = index ;i < errorTextArr.length;i++){
				errorText += errorTextArr[i] + "\n";
			}
			if (!bo.flag) {
				// 调用提示框
				alert(errorText+"请仔细检查您填写的信息！");
				return;
			}
		}
	}
	function beforeSubmit(){
		var selects = $("select");
		var valueAndtext = "";
		if(selects){
			for(var i = 0 ;i < selects.length;i++){
				var tempSel = selects[i];
				var selValue = $(tempSel).attr("value");
				var text = $(tempSel).find("option:selected").text();
				var trObj =  $(tempSel).parent().parent().parent();
				var sedTd = trObj.find("td");
				var tdOjb =sedTd.eq(1);
				var input =$(tdOjb).find("input").eq(0);
				var annexValue = $(input).attr("value");				
				valueAndtext += selValue+"_"+text+"_"+annexValue+";";
			}	
			$("#type_img").attr("value",valueAndtext);
		}
	}
	function validationEngine(){
		var ids = ["fundName","price","annualized","remittance","term","legal","fundSize","fundTime","fundTeam","partner","fundsBusiness","bank","company","subscribedFund","fundType","expectedReturn","fundsWay","repayment"];
		var flag = false;
		for(var i = 0 ;i < ids.length;i++){
			var inputObj = $("#"+ids[i]);
			var value = inputObj.attr("value");
			if(null!=inputObj){
				if(null!=value && ""!=value){
					if(ids[i]=="price"){
						if(!isNaN("price")){
							flag = false;
							return {
								index:i,
								flag:flag
							};
						}
						continue;
					}
					continue;
					return {
						index:i,
						flag:flag
					};
				}else{
					return {
						index:i,
						flag:flag
					};;
				}
			}else{
				return {
					index:i,
					flag:flag
				};;
			}
		}
	}
	
	function changImg(objId, objType, fileType) {
		$.ajaxFileUpload({
			url : '${ctx }/upfs/uploadFiles', //上传文件的服务端
			secureuri : false, //是否启用安全提交
			dataType : 'text', //数据类型  
			fileElementId : objId, //表示文件域ID
			data : {
				'folder' : fileType
			},//上传所在文件夹
			//提交成功后处理函数      html为返回值，status为执行的状态
			success : function(data, status, d) {
				var obj = jQuery.parseJSON(data);
				$("#" + objId)
						.before(
								"<div><input type=\"hidden\"  class="+objType+" name=\"saveFile\" value="+obj.saveFile+"><span>"
										+ obj.fileUpName
										+ "</span><a style=\"margin-left: 5px;\" onclick=\"delImg(this)\" id='"
										+ obj.saveFile
										+ "' name='"
										+ objId
										+ "'>x</a></div>");
				var uploadedFiles = $(".prmsCulum1");
				var uploadedFiledUrl = "";
				for(var i = 0 ; i < uploadedFiles.length;i++){
					if(uploadedFiles[i]){
						uploadedFiledUrl += $(uploadedFiles[i]).attr("value")+";";
					}
				}
				$("#fund_file").attr("value",uploadedFiledUrl);
				$("#" + objId).siblings('img').remove();
				rtListPrmsSort();
			},
			//提交失败处理函数
			error : function(data, status, e) {
			}
		});
	}

	function delImg(obj) {
		$(obj).parent().remove();
		$("#" + $(obj).attr("name")).show();
	}
	var trNum = 0;
	//文件类型的添加
   	var fileTypeStr = "<div class='col-md-6'><select name='fileType' id='fileType' class='validate[required]'>"
   			+"<c:forEach items='${warrant }' var='warrant'><option value='${warrant.key }'>${warrant.value }</option></c:forEach>"+"</select></div>";
   	//向页面输出文件类型和原件上传
	function addTr(tbaleId, fileType) {
		if (fileType == "scfItemAnnexList") {
			var str = "<tr><td>"+fileTypeStr+"</td>"
					+ "<td><input type=\"file\" name=\"file\" id=\"file_upload"
					+ (trNum)
					+ "\" onchange=\"changImg('file_upload"
					+ trNum
					+ "','prmsCulum1','"
					+ fileType
					+ "')\" /></td></tr>";
		}
		trNum++;
		$("#" + tbaleId).append(str);
		rtListPrmsSort();
	}

	function rtListPrmsSort() {
		$(".prmsCulum0").each(
				function(index, element) {
					$(element).attr("name",
							"scfItemAnnexList[" + index + "].fileType");
		});
		$(".prmsCulum1").each(
				function(index, element) {
					$(element)
							.attr(
									"name",
									 "scfItemAnnexList[" + index
											+ "].fileUrl");
		}); 
				
	}
</script>
<body class="scrollY frameContent">
	<div class="col-infos">
		<h2>
			<i class="fa fa-bar-chart-o"></i>添加基金产品
		</h2>
	</div>
	<form action="${ctx }/fund/saveorUpdatefund"
		class="form-inline" id="mgFrm" method="post">
		<div class="form-group" style="display: none;">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>id</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="title" name="title" class="form-control"
					style="width: 250px;" maxlength="25"> <input type="hidden"
					id="id" name="id" class="form-control" style="width: 250px;"
					maxlength="25" value="${fund.id }">
			</div>
		</div>
		<div style="display: none;">
			<input type="hidden"  name="files" id="fund_file">
			<input type="hidden" id="type_img" name="valueAndText"> 
		</div>
		<table align="center" width="68%" id="addScfItemAnnex" cellpadding="1" cellspacing="1" >
			<tr>
				<th>文件类别</th>
				<th>原件上传</th>
			</tr>
			<c:if test="${fundType!=1}">
				<tr>
					<td>
						<div class="col-md-6">
	                  			<select name="fileType" id="fileType" class="validate[required]" onchange="">
									<c:forEach items="${warrant }" var="warrant">
										<option value="${warrant.key }">${warrant.value }</option>
									</c:forEach>
								</select>
	                  	</div>
					</td>
					<td><input type="file" name="file" id="original" onchange="changImg('original','prmsCulum1','scfItemAnnexList')"/></td>
				</tr>
			</c:if>
		</table>
		<table>
			<tr>
			  <td><a href="javascript:;" style="margin-left:200px;" onclick="addTr('addScfItemAnnex','scfItemAnnexList')">+添加附件</a></td>
			</tr>
		</table> 
		<input type="hidden" name="getAddUserName" value="${eopEnterprise.userName}">
		<input type="hidden" name="getAddEnName" value="${eopEnterprise.enterpriseName}">
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金项目名称</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundName" name="fundName"
					class="form-control validate[required]" style="width: 250px;" maxlength="50"
					value="${fund.fundName }" >
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>募集金额</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="price" name="price"
					class="form-control validate[required,custome[isNumberOr_OrLetterFirst]]" style="width: 250px;" maxlength="50" value="${fund.price }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>年化收益</label>
			<div style="float: right;margin-left: 10px;">
					<input type="text" id="annualized" name="annualized"
					class="form-control validate[required]" style="width: 250px;" maxlength="50" value="${fund.annualized }">%
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>回款方式</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="remittance" name="remittance"
					class="form-control validate[required,custom[number]]" style="width: 250px;" maxlength="50" value="${fund.remittance }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>期限</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="term" name="term"
					class="form-control validate[required]" style="width: 250px;" maxlength="50" value="${fund.term }">月
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>法律形式</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="legal" name="legal"
					class="form-control validate[required] " style="width: 250px;" maxlength="50" value="${fund.legal }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金总规模</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundSize" name="fundSize"
					class="form-control validate[required] " style="width: 250px;" maxlength="50" value="${fund.fundSize }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金存续期</label>
			<div style="float: right;margin-left: 10px;">
			<input type="text" id="fundTime" name="fundTime"
					class="form-control validate[required] " style="width: 250px;" maxlength="50" value="${fund.fundTime }">月
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金管理人</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundTeam" name="fundTeam" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.fundTeam }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>有限合伙人</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="partner" name="partner" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.partner }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>用款企业</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundsBusiness" name="fundsBusiness" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.fundsBusiness }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>托管银行</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="bank" name="bank" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.bank }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>担保公司</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="company" name="company" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.company }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>认缴基金</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="subscribedFund" name="subscribedFund" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.subscribedFund }">元
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金类别</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundType" name="fundType" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.fundType }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>预期收益</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="expectedReturn" name="expectedReturn" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.expectedReturn }">%
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>基金用途</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="fundsWay" name="fundsWay" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.fundsWay }">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>还款来源</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="repayment" name="repayment" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="${fund.repayment }">
			</div>
		</div>
			<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>结束日期</label>
			<div style="float: right;margin-left: 10px;">
				<input type="text" id="endDate" name="endDate" class="form-control validate[required]"
					style="width: 250px;" maxlength="50" value="<fmt:formatDate value="${fund.endDate }" pattern="yyyy-MM-dd"/>">
			</div>
		</div>
		<div class="form-group-list">
			<label for="" class="from-group-label"><font color="red"
				style="text-align: center; padding-top: 3px;">*</font>保障措施</label>
			<div style="float: right;margin-left: 10px;">
					<textarea id="safeguards" name="safeguards" rows="10"   class="validate[required]" style="width: 500px;height: 100px; position: static" class="editMode">${fund.safeguards }</textarea>
			</div>
		</div>
	
		<script type="text/javascript">
			 $(document).ready(function(){
	       	  var endDate = {
				    elem: '#endDate',
				    min: laydate.now(), //-1代表昨天，-2代表前天，以此类推
				};
			  laydate(endDate);
	         });
		</script>
		<input id="fileUrl" type="hidden" name="fileUrl">
		<div class="form-group-list" style="margin-left: 400px;">
			<button type="button" class="btn btn-primary" onclick="save();">保存</button>
		</div>
	</form>
</body>

</html>
