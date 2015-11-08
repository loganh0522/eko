$(document).ready(function() {
    $(".bhoechie-tab-menu>list-group>a").click(function(e) {
        e.preventDefault();
        $(this).siblings('a.active').removeClass("active");
        $(this).addClass("active");
        var index = $(this).index();
        $(".bhoechie-tab>.bhoechie-tab-content").removeClass("active");
        $(".bhoechie-tab>.bhoechie-tab-content").eq(index).addClass("active");
    });
});

