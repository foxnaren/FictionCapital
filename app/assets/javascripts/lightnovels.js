<script type="text/javascript">
  var checkbox = document.getElementById('lightnovel_is_translated');
  var details_div = document.getElementById('translated');
  checkbox.onchange = function() {
     if(this.checked) {
       details_div.style['display'] = 'block';
     } else {
       details_div.style['display'] = 'none';
     }
  };
</script>