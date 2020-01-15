function changeSelBtn(index){
    if(index==1){
        $("#btn1").addClass('ch_cls');
        $("#btn2").removeClass('ch_cls');
        $("#btn3").removeClass('ch_cls');
    }else if(index==2){
        $("#btn1").removeClass('ch_cls');
        $("#btn2").addClass('ch_cls');
        $("#btn3").removeClass('ch_cls');
        
    }else if(index==3){
        $("#btn1").removeClass('ch_cls');
        $("#btn2").removeClass('ch_cls');
        $("#btn3").addClass('ch_cls');
    }
}
