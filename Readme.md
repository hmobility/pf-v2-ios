#  Build

1. Naver Map Framework 설치 방법 

    - git-lfs를 설치하지 않으면 바이너리대신 설정파일만 받아오게 되어 컴파일시 오류 발생
    - 정상적으로 다운받은 프레임워크의 용량(190 MB) 확인 필요 
    - 기존 Cocoapod 의 소스 설치된 경우 설치 안되는 경우 있음 
    
```
    sudo gem install cocoapods // cocoapods 설치
    brew install git-lfs       // homebrew 사용시 git-lfs 설치
    git-lfs install            // git-lfs 이니셜라이즈
    pod install --repo-update
```

2. git-lfs Clean 방법
```
    1. pod cache clean NMapsMap pod 캐시를 날린후
    2. pod install
    3. 클린 (cmd+shift+option+k) 후 재빌드 
```

# Localization


1.  규칙
    - [태그]_[서브 태그]_[명사]_[동사 or 명사] 순
    - 예제 
```
	  btn_password_find
	  ph_input_account
	  dsc_password_find
	  itm_white
```  


2. 태그 종류
    1. 메인 태그
        -  btn : 버튼 명칭
        -  txt : 일반 텍스트
        -  msg : 팝업 메시지
        -  ttl : 타이틀 (네비게이션, 입력필드 등)
        -  ph : placeholder (입력창)
        -  dsc : 상세 설명 문장
        -  itm : 항목 (색상 등)
    2. 서브 태그
        - input : 입력창
  
    
3.  예제
``` 
    [ 로그인 ] -> btn
    기존 회원이신 경우 정보이관 버튼을 눌러 주세요. - -> txt
    _기존 정보 이관하기_ -> btn
    ID(휴대폰번호)를 입력하세요 -> ph
    휴대폰 인증 -> ttl
    로그인을 위해 휴대폰 인증이필요합니다. -> dsc
``` 