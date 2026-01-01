<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Fundraising Thermometer</title>
<style>
  :root{
    --track-bg:#e9eef4;
    --fill-bg:linear-gradient(180deg,#2ea3d6,#0077b6);
    --accent:#005f96;
    --text:#0b2b3a;
    --muted:#6b7c86;
    --radius:999px;
  }

  .thermometer {
    max-width:480px;
    margin:16px auto;
    font-family:system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial;
    color:var(--text);
  }

  .thermometer-track{
    position:relative;
    height:28px;
    background:var(--track-bg);
    border-radius:var(--radius);
    overflow:hidden;
    box-shadow:inset 0 1px 0 rgba(255,255,255,0.6);
  }

  .thermometer-fill{
    position:absolute;
    left:0;
    top:0;
    bottom:0;
    width:0%;
    background:var(--fill-bg);
    transition:width 800ms cubic-bezier(.2,.8,.2,1);
    display:flex;
    align-items:center;
    justify-content:flex-end;
    padding-right:8px;
    color:white;
    font-weight:600;
    border-radius:var(--radius) 0 0 var(--radius);
    box-shadow: 0 1px 0 rgba(255,255,255,0.12) inset;
  }

  .thermometer-fill.over{
    box-shadow:0 0 0 3px rgba(0,119,182,0.08);
  }

  .thermometer-labels{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-top:8px;
    gap:8px;
    font-size:0.94rem;
  }

  .thermometer-raised{
    color:var(--accent);
    font-weight:700;
  }

  .thermometer-goal{
    color:var(--muted);
    font-size:0.9rem;
  }

  /* small screens */
  @media (max-width:420px){
    .thermometer { padding:0 8px; }
    .thermometer-track { height:22px; }
  }
</style>
</head>
<body>

<!-- Set data-raised and data-goal attributes (numbers only, no $) -->
<div class="thermometer" id="thermo1" role="img"
     aria-label="Fundraising progress" data-raised="5250" data-goal="10000">
  <div class="thermometer-track" aria-hidden="true">
    <div class="thermometer-fill" id="thermo1-fill">0%</div>
  </div>

  <div class="thermometer-labels" aria-hidden="false">
    <div class="thermometer-raised" id="thermo1-raised">$0</div>
    <div class="thermometer-goal" id="thermo1-goal">Goal $0</div>
  </div>
</div>

<script>
(function formatCurrency(n){
  // small helper returned by closure
  return function(n){
    return new Intl.NumberFormat(undefined, { style:'currency', currency:'USD', maximumFractionDigits:0 }).format(n);
  };
})();

document.addEventListener('DOMContentLoaded', function(){
  // Handle any .thermometer on the page
  document.querySelectorAll('.thermometer').forEach(function(container){
    var raised = Number(container.getAttribute('data-raised') || 0);
    var goal   = Number(container.getAttribute('data-goal') || 0);

    // fallback if numbers are not parseable
    if (isNaN(raised)) raised = 0;
    if (isNaN(goal) || goal <= 0) goal = 0;

    var fillEl = container.querySelector('.thermometer-fill');
    var raisedEl = container.querySelector('.thermometer-raised');
    var goalEl = container.querySelector('.thermometer-goal');

    var percent = goal > 0 ? (raised / goal) * 100 : 0;
    // for visual fill we cap at 100% but allow >100% indicated by class
    var visualPercent = Math.min(percent, 100);

    // update UI
    fillEl.style.width = visualPercent.toFixed(2) + '%';
    // apply over-goal styling if >100%
    if (percent > 100) fillEl.classList.add('over');

    // format currency (USD by default). Change currency code as needed.
    var formatter = new Intl.NumberFormat(undefined, { style:'currency', currency:'USD', maximumFractionDigits:0 });
    raisedEl.textContent = formatter.format(raised);
    goalEl.textContent = 'Goal ' + formatter.format(goal);

    // show percentage inside fill only when there's room (>=8%)
    if (visualPercent >= 8) {
      fillEl.textContent = Math.round(percent) + '%';
    } else {
      fillEl.textContent = '';
    }

    // update accessible label
    var ariaLabel = 'Raised ' + formatter.format(raised) + (goal > 0 ? (' of ' + formatter.format(goal) + ' (' + Math.round(percent) + '%)') : '');
    container.setAttribute('aria-label', ariaLabel);
  });
});
</script>
</body>
</html>
