<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %><!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><la:message key="labels.admin_brand_title"/> | <la:message
            key="labels.webauth_configuration"/></title>
    <jsp:include page="/WEB-INF/view/common/admin/head.jsp"></jsp:include>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp">
        <jsp:param name="menuCategoryType" value="crawl"/>
        <jsp:param name="menuType" value="webAuthentication"/>
    </jsp:include>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>
                            <la:message key="labels.webauth_configuration"/>
                        </h1>
                    </div>
                    <div class="col-sm-6">
                        <jsp:include page="/WEB-INF/view/common/admin/crud/breadcrumb.jsp"></jsp:include>
                    </div>
                </div>
            </div>
        </div>
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <c:if test="${!displayCreateLink}">
                        <la:link href="../webconfig/" styleClass="btn btn-primary ${f:h(editableClass)}">
                            <em class="fa fa-arrow-circle-right"></em>
                            <la:message key="labels.webauth_create_web_config"/>
                        </la:link>
                    </c:if>
                    <c:if test="${displayCreateLink}">
                        <div class="card card-outline card-primary">
                            <div class="card-header">
                                <jsp:include page="/WEB-INF/view/common/admin/crud/header.jsp"></jsp:include>
                            </div>
                            <div class="card-body">
                                    <%-- Message --%>
                                <div>
                                    <la:info id="msg" message="true">
                                        <div class="alert alert-info">${msg}</div>
                                    </la:info>
                                    <la:errors/>
                                </div>
                                    <%-- List --%>
                                <c:if test="${webAuthPager.allRecordCount == 0}">
                                    <div class="row top10">
                                        <div class="col-sm-12">
                                            <em class="fa fa-info-circle text-primary"></em>
                                            <la:message key="labels.list_could_not_find_crud_table"/>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${webAuthPager.allRecordCount > 0}">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                        <tr>
                                            <th><la:message key="labels.webauth_list_hostname"/></th>
                                            <th><la:message
                                                    key="labels.webauth_list_web_crawling_config"/></th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="data" varStatus="s"
                                                   items="${webAuthenticationItems}">
                                            <tr
                                                    data-href="${contextPath}/admin/webauth/details/4/${f:u(data.id)}">
                                                <td><c:if
                                                        test="${data.hostname==null||data.hostname==''}">
                                                    <la:message key="labels.webauth_any"/>
                                                </c:if> ${f:h(data.hostname)}: <c:if
                                                        test="${data.port==null||data.port==''}">
                                                    <la:message key="labels.webauth_any"/>
                                                </c:if> ${f:h(data.port)}</td>
                                                <td>${f:h(data.webConfig.name)}</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                    <c:set var="pager" value="${webAuthPager}" scope="request"/>
                                    <c:import url="/WEB-INF/view/common/admin/crud/pagination.jsp"/>
                                    <c:if test="${pager.currentPageNumber > pager.allPageCount}">
                                        <script>location.href = "${contextPath}/admin/webauth/list/${pager.allPageCount}";</script>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
    <jsp:include page="/WEB-INF/view/common/admin/footer.jsp"></jsp:include>
</div>
<jsp:include page="/WEB-INF/view/common/admin/foot.jsp"></jsp:include>
</body>
</html>
