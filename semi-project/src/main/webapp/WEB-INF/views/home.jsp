<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <title>여기다가 우리꺼 이름 넣을 예정</title>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css">
  </head>

  <body>
    <%@ include file="./include/header.jsp" %>
      <%@ include file="./include/sidebar.jsp" %>

        <div class="bodywrap">
          bodywrap
          <h2>${body.totalCount}</h2>

          <div id="map" style="width: 100%; height: 90%;"></div>

          <!-- 나재성이 만든 대충 테스트용 폼 -->
          <form id="myForm" action="${pageContext.request.contextPath}/api/req/" method="GET">
            <input type="input" name="h1" value="11110640" />
            <input type="input" name="h2" value="I21201" />
            <button type="button" id="checkBtn2">이건 소분류 포커스 벗어나면 할거</button>
            <button type="submit" id="checkBtn">조회</button>
          </form>
          <!-- 테스트용 폼 -->
          <img alt="" class="category ico_comm" src="${pageContext.request.contextPath}/img/Marker.png">
          <hr>
          <img alt="" class="category ico_coffee" src="${pageContext.request.contextPath}/img/Marker.png">
          <hr>
          <img alt="" class="category ico_store" src="${pageContext.request.contextPath}/img/Marker.png">
          <hr>
          <img alt="" class="category ico_carpark" src="${pageContext.request.contextPath}/img/Marker.png">
        </div>
        
        



        <script type="text/javascript" src="${reqUrl}?appkey=${serviceKey}&libraries=clusterer"></script>
        <script>
          window.onload = function () {
            var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
              mapOption = {
                center: new kakao.maps.LatLng(${ lat }, ${ lon }), // 지도의 중심좌표 // 전달받은 첫번째 json을 가공해서 중심이 어디 있는지 표시하고
                level: 1 // 지도의 확대 레벨
              };

            var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

            var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', // 마커이미지의 주소입니다    
              imageSize = new kakao.maps.Size(44, 49), // 마커이미지의 크기입니다
              imageOption = { offset: new kakao.maps.Point(27, 69) }; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.

            // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
              markerPosition = new kakao.maps.LatLng(${ lat }, ${ lon }); // 마커가 표시될 위치입니다

            // 마커를 생성합니다
            var marker = new kakao.maps.Marker({
              position: markerPosition,
              image: markerImage // 마커이미지 설정 
            });

            // 마커가 지도 위에 표시되도록 설정합니다
            marker.setMap(map);

            // 커스텀 오버레이에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
            var content = '<div class="customoverlay">' +
              '  <a href="https://map.kakao.com/?q=' + ${ lat } + ',' + ${ lon } + '" target="_blank">' +
                '    <span class="title">현재 위치</span>' +
                '  </a>' +
                '</div>';


            // 커스텀 오버레이가 표시될 위치입니다 
            var position = new kakao.maps.LatLng(${ lat }, ${ lon });

            // 커스텀 오버레이를 생성합니다
            var customOverlay = new kakao.maps.CustomOverlay({
              map: map,
              position: position,
              content: content,
              yAnchor: 1
            });

            // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
            var mapTypeControl = new kakao.maps.MapTypeControl();

            // 지도에 컨트롤을 추가해야 지도위에 표시됩니다
            // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOP RIGHT는 오른쪽 위를 의미합니다
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

            // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
            var zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
          }; // window.onload() 끝


          // 조회버튼
          document.getElementById('myForm').addEventListener('submit', function (e) {
            e.preventDefault(); // 폼 기본 동작인 페이지 새로고침 방지
            
            // 조회 전에 action 저장
            const originalAction = this.action;
            
            const $h1 = document.querySelector('input[name=h1]').value;
            const $h2 = document.querySelector('input[name=h2]').value;
            // console.log($h1);
            // console.log($h2);
            this.action = this.action + $h1 + '/' + $h2; // 폼의 action 속성 변경
            // console.log(this.action);
            this.submit(); // 폼 데이터 서버로 전송
            
         	// 조회 후에 action 속성을 원래대로 초기화
            this.action = originalAction;
          }); // 조회버튼 끝


          // json형식으로 불러왔을 때 마커 반복하면서 찍고, 많은 마커들을 클러스터를 이용해서 (무수한 마커 대신에 그 주위 영역 안에 얼마나 있는지) 
          // 이걸로 주위 범위 찍어주는 대신 사용하면 될듯?
          document.getElementById('checkBtn2').onclick = () => {
            refresh();
          }
          function refresh() {
            var map = new kakao.maps.Map(document.getElementById('map'), { // 지도를 표시할 div
              center: new kakao.maps.LatLng(36.2683, 127.6358), // 지도의 중심좌표 
              level: 14 // 지도의 확대 레벨 
            });

            // 마커 클러스터러를 생성합니다 
            var clusterer = new kakao.maps.MarkerClusterer({
              map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
              averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
              minLevel: 10 // 클러스터 할 최소 지도 레벨 
            });

            // 데이터를 가져오기 위해 jQuery를 사용합니다
            // 데이터를 가져와 마커를 생성하고 클러스터러 객체에 넘겨줍니다
            $.get("https://apis.map.kakao.com/download/web/data/chicken.json", function (data) {
              // 데이터에서 좌표 값을 가지고 마커를 표시합니다
              // 마커 클러스터러로 관리할 마커 객체는 생성할 때 지도 객체를 설정하지 않습니다
              var markers = $(data.positions).map(function (i, position) {
                return new kakao.maps.Marker({
                  position: new kakao.maps.LatLng(position.lat, position.lng)
                });
              });

              // 클러스터러에 마커들을 추가합니다
              clusterer.addMarkers(markers);
            });
          }// refresh() 끝
        </script>
  </body>

  </html>