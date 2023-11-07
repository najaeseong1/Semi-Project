<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>여기다가 우리꺼 이름 넣을 예정</title>
<link href="${pageContext.request.contextPath}/css/minireset.css"
	rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/side.css"
	rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/searchSale.css"
	rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/searchSale.css"
	rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/header.css"
	rel="stylesheet" type="text/css">
</head>

<body>
	<%@ include file="./include/header.jsp"%>
	<%@ include file="./include/sidebar.jsp"%>

	<div id="container">
		<article id="saleList">
			<div id="saleList2">
				<div id="saleStatus">
					<!-- 이화동 상권 조회 -->
					<h3>adongNm 상권조회</h3>
					<ul class="tabnav">
						<li>indsSclsNm가맹점총 : totalCount개</li>
						<li>카페 가맹점 총 : 84 개</li>
					</ul>
				</div>
				<!--반복문 돌릴 곳-->
				<div id="ListContents">
					<div>index bizesNm lnoAdr</div>
					<div>201. 서울커피 서울특별시 종로구 연건동 84-1</div>
				</div>
			</div>
		</article>
		<article id="map"></article>
	</div>
	<%@ include file="./include/footer.jsp"%>



	<script type="text/javascript"
		src="${reqUrl}?appkey=${serviceKey}&libraries=clusterer"></script>
	<script>
	
	const body = JSON.parse('${body}'); // 서버 kakaoController에서 이미 자바스크립트에서 바로 사용할 수 있는 json 형태로 변환해서 사용가능
	const items = body.items;
//	console.log(items);
	
	  var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	      center: new kakao.maps.LatLng(body.items[0].lat, body.items[0].lon), // 지도의 중심좌표 // 전달받은 첫번째 json을 가공해서 중심이 어디 있는지 표시하고
	      level: 1 // 지도의 확대 레벨
	    };
	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	window.onload = function () {
		saleListSetUp();
		// 마커를 클릭했을 때 해당 장소의 상세정보를 보여줄 커스텀오버레이입니다
		var placeOverlay = new kakao.maps.CustomOverlay({zIndex:1}), contentNode = document.createElement('div'); // 커스텀 오버레이의 컨텐츠 엘리먼트 입니다 
		    
		  mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = {
		      center: new kakao.maps.LatLng(body.items[0].lat, body.items[0].lon), // 지도의 중심좌표 // 전달받은 첫번째 json을 가공해서 중심이 어디 있는지 표시하고
		      level: 1 // 지도의 확대 레벨
		    };
		
		  map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		  // 여기서 카페인지 은행인지 주유소인지 병원이지 등등등 을 if로 body.items.bizesNm랑 비교해서 마커 이미지 설정
		  var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/category.png', // 마커이미지의 주소입니다 //스프라이트 이미지
		    imageSize = new kakao.maps.Size(28, 28), // 마커이미지의 크기입니다
		          imageOption = {  
		              spriteOrigin: new kakao.maps.Point(8, 0),    
		              spriteSize: new kakao.maps.Size(36, 98)  
		          };     
		
			// 반복문 시작
			items.forEach((item, index) => {
			    var markerPosition = new kakao.maps.LatLng(item.lat, item.lon); // 마커가 표시될 위치입니다

			    // 마커를 생성합니다
			    var marker = new kakao.maps.Marker({
			        position: markerPosition,
			        image: new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption) // 마커이미지 설정 
			    });

			    // 마커가 지도 위에 표시되도록 설정합니다
			    marker.setMap(map);

			    // 마커에 클릭 이벤트를 등록합니다
			    kakao.maps.event.addListener(marker, 'click', () => {
			        // 클릭한 마커에 대한 정보를 사용하여 커스텀 오버레이를 표시하는 함수를 호출합니다
			        displayPlaceInfo(item, index); // index 매개변수 추가
			    });
			});
			// 반복문 끝
			
			// 클릭한 마커에 대한 장소 상세정보를 커스텀 오버레이로 표시하는 함수입니다
			function displayPlaceInfo(item) {
			    var content = '<div class="placeinfo">' +
			                    '<a class="title" href="https://map.kakao.com/?q=' + item.lnoAdr + '" target="_blank" title="' + item.bizesNm + '">' + item.bizesNm + '</a>'+
			                    '<span title="' + item.lnoAdr + '">' + item.lnoAdr + '</span>' +
			                    '<span class="jibun" title="' + item.rdnmAdr + '">(지번 : ' + item.rdnmAdr + ')</span>';

			    contentNode.innerHTML = content;
			    placeOverlay.setPosition(new kakao.maps.LatLng(item.lat+0.0002, item.lon));
			    placeOverlay.setMap(map);  
			}
			
			// 커스텀 오버레이 컨텐츠를 설정합니다
			placeOverlay.setContent(contentNode);  
			
			//마커와 오버레이 상태
			
			
		    
		  // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
		  var mapTypeControl = new kakao.maps.MapTypeControl();
		
		  // 지도에 컨트롤을 추가해야 지도위에 표시됩니다
		  // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOP RIGHT는 오른쪽 위를 의미합니다
		  map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
		
		  // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		  var zoomControl = new kakao.maps.ZoomControl();
		  map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
		}; // window.onload() 끝
		
		
		// 조회 결과 대입
		var saleListSetUp = () => {
			document.querySelector('#saleStatus h3').innerText = items[0].adongNm + ' 상권 조회';
		    document.querySelector('#saleStatus .tabnav li').innerText = items[0].indsSclsNm+'가맹점 총 : '+body.totalCount+' 개';

		    // ListContents 내부를 비웁니다
		    const listContents = document.querySelector('#ListContents');
		    listContents.innerHTML = '';

		    // items 배열의 각 요소에 대해 div 생성 후 추가
		    items.forEach((item, idx) => {
		        const div = document.createElement('div');
		        div.innerHTML = '<div>'+idx+'. '+ item.bizesNm+ item.lnoAdr + '<button onclick="panTo(' + idx + ')">위치보기</button>'+'</div>';
		        listContents.appendChild(div);
		    });
		};// 조회 결과 대입 끝
		
		
		var panTo = (idx) => {
		    // 이동할 위도 경도 위치를 생성합니다 
		    var moveLatLon = new kakao.maps.LatLng(items[idx].lat, items[idx].lon);
		    
		    // 지도 중심을 부드럽게 이동시킵니다
		    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		    map.panTo(moveLatLon);            
		}        
</script>
</body>

</html>