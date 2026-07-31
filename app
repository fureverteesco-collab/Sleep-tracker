!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="theme-color" content="#1a1a2e">
<link rel="apple-touch-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>😴</text></svg>">
<title>Sleep Tracker</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, sans-serif; background: #1a1a2e; color: #eee; padding: 15px; min-height: 100vh; }
.container { max-width: 500px; margin: 0 auto; }
h1 { text-align: center; color: #e94560; margin: 10px 0 20px; font-size: 1.8em; }
.card { background: #16213e; border-radius: 15px; padding: 15px; margin-bottom: 15px; }
.btn { background: #e94560; color: white; border: none; padding: 12px; border-radius: 10px; width: 100%; font-size: 1em; margin-top: 10px; cursor: pointer; }
.btn2 { background: #0f3460; }
label { display: block; margin: 10px 0 3px; color: #aaa; font-size: 0.85em; }
input, select, textarea { width: 100%; padding: 10px; background: #0f3460; border: none; border-radius: 8px; color: white; font-size: 1em; margin-bottom: 5px; }
.stats { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
.stat { background: #0f3460; padding: 12px; border-radius: 10px; text-align: center; }
.stat-val { font-size: 1.4em; font-weight: bold; color: #e94560; }
.stat-lbl { font-size: 0.75em; color: #aaa; margin-top: 3px; }
.tab-bar { display: flex; background: #16213e; border-radius: 20px; padding: 3px; margin-bottom: 15px; }
.tab { flex: 1; text-align: center; padding: 8px; border-radius: 18px; font-size: 0.85em; cursor: pointer; }
.tab.active { background: #e94560; }
.hidden { display: none; }
.sleep-item { background: #0f3460; padding: 10px; border-radius: 8px; margin-bottom: 8px; font-size: 0.9em; }
.stars { display: flex; gap: 5px; margin: 8px 0; }
.star { font-size: 2em; cursor: pointer; color: #0f3460; }
.star.on { color: #ffd700; }
.timer { font-size: 2.5em; text-align: center; margin: 15px 0; font-weight: bold; }
.sound-btn { background: #0f3460; padding: 12px; border-radius: 8px; margin-bottom: 8px; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 0.9em; }
.sound-btn.on { background: #e94560; }
.score-circle { width: 100px; height: 100px; border-radius: 50%; background: conic-gradient(#e94560 0% var(--pct), #0f3460 var(--pct) 100%); display: flex; align-items: center; justify-content: center; margin: 10px auto; }
.score-inner { width: 75px; height: 75px; border-radius: 50%; background: #16213e; display: flex; align-items: center; justify-content: center; font-size: 1.8em; font-weight: bold; }
.center { text-align: center; }
.streak { display: inline-block; background: #ffd700; color: #000; padding: 3px 10px; border-radius: 10px; font-size: 0.8em; font-weight: bold; margin-left: 5px; }
</style>
</head>
<body>
<div class="container">
<h1>😴 Sleep Tracker</h1>

<div class="tab-bar">
<div class="tab active" onclick="showTab('home')">Home</div>
<div class="tab" onclick="showTab('log')">Log</div>
<div class="tab" onclick="showTab('sounds')">Sounds</div>
</div>

<div id="home">
<div class="card center">
<h3>Last Night</h3>
<div class="score-circle" id="scoreRing" style="--pct:0%"><div class="score-inner" id="sleepScore">--</div></div>
<p id="lastDuration">No data yet</p>
</div>
<div class="stats">
<div class="stat"><div class="stat-val" id="avgDur">0h</div><div class="stat-lbl">Avg Sleep</div></div>
<div class="stat"><div class="stat-val" id="streak">0</div><div class="stat-lbl">Day Streak 🔥</div></div>
<div class="stat"><div class="stat-val" id="debt">0h</div><div class="stat-lbl">Sleep Debt</div></div>
<div class="stat"><div class="stat-val" id="avgQual">0</div><div class="stat-lbl">Avg Quality ⭐</div></div>
</div>
<div class="card"><h3>History</h3><div id="history"></div></div>
</div>

<div id="log" class="hidden">
<div class="card">
<h3>Log Sleep</h3>
<label>Date</label><input type="date" id="sdate">
<label>Went to bed</label><input type="time" id="bed" value="23:00">
<label>Woke up</label><input type="time" id="wake" value="07:00">
<label>Quality</label>
<div class="stars" id="stars">
<span class="star on" onclick="setQ(1)">★</span>
<span class="star on" onclick="setQ(2)">★</span>
<span class="star on" onclick="setQ(3)">★</span>
<span class="star" onclick="setQ(4)">★</span>
<span class="star" onclick="setQ(5)">★</span>
</div>
<label>Notes (optional)</label><textarea id="notes" rows="2" placeholder="Dreams, feelings..."></textarea>
<button class="btn" onclick="save()">💾 Save</button>
</div>
<div class="card center">
<h3>Sleep Timer</h3>
<div class="timer" id="timerDisp">00:00:00</div>
<button class="btn" id="timerBtn" onclick="toggleTimer()">▶ Start</button>
</div>
</div>

<div id="sounds" class="hidden">
<div class="card">
<h3>Sleep Sounds</h3>
<div class="sound-btn" onclick="playS('white')">📻 White Noise</div>
<div class="sound-btn" onclick="playS('rain')">🌧️ Rain</div>
<div class="sound-btn" onclick="playS('ocean')">🌊 Ocean</div>
<div class="sound-btn" onclick="playS('forest')">🌲 Forest</div>
<label>Auto-stop</label>
<select id="autoStop"><option value="0">Don't stop</option><option value="15">15 min</option><option value="30">30 min</option><option value="60">1 hour</option></select>
</div>
</div>
</div>

<script>
let data = JSON.parse(localStorage.getItem('sd') || '[]');
let qual = 3, tInt, tSec = 0, aCtx;
document.getElementById('sdate').valueAsDate = new Date();

function showTab(t) {
document.querySelectorAll('.tab').forEach(x => x.classList.remove('active'));
document.querySelectorAll('#home,#log,#sounds').forEach(x => x.classList.add('hidden'));
document.getElementById(t).classList.remove('hidden');
event.target.classList.add('active');
if(t === 'home') update();
}

function setQ(r) {
qual = r;
document.querySelectorAll('#stars .star').forEach((s,i) => s.classList.toggle('on', i < r));
}

function save() {
const bed = document.getElementById('bed').value;
const wake = document.getElementById('wake').value;
const date = document.getElementById('sdate').value;
const b = new Date(date + ' ' + bed), w = new Date(date + ' ' + wake);
if(w <= b) w.setDate(w.getDate() + 1);
const dur = (w - b) / 3600000;
data.push({date, bed, wake, dur, qual, notes: document.getElementById('notes').value, ts: Date.now()});
data.sort((a,b) => b.ts - a.ts);
if(data.length > 100) data = data.slice(0,100);
localStorage.setItem('sd', JSON.stringify(data));
document.getElementById('notes').value = '';
alert('Saved! 💤');
update();
}

function update() {
if(!data.length) return;
const last = data[0];
let score = last.dur >= 7 && last.dur <= 9 ? 50 : last.dur >= 6 ? 35 : 20;
score += last.qual * 10;
score = Math.min(100, score);
document.getElementById('sleepScore').textContent = score;
document.getElementById('scoreRing').style.setProperty('--pct', score + '%');
document.getElementById('lastDuration').textContent = last.dur.toFixed(1) + ' hours';

const avgD = data.reduce((a,b) => a + b.dur, 0) / data.length;
const avgQ = data.reduce((a,b) => a + b.qual, 0) / data.length;
document.getElementById('avgDur').textContent = avgD.toFixed(1) + 'h';
document.getElementById('avgQual').textContent = avgQ.toFixed(1);

let str = 0;
for(let s of data) { if(s.dur >= 6) str++; else break; }
document.getElementById('streak').textContent = str;

const need = 8 * Math.min(data.length, 7);
const actual = data.slice(0,7).reduce((a,b) => a + b.dur, 0);
document.getElementById('debt').textContent = Math.max(0, need - actual).toFixed(1) + 'h';

document.getElementById('history').innerHTML = data.slice(0,7).map(s =>
`<div class="sleep-item"><strong>${s.date}</strong> · ${s.dur.toFixed(1)}h · ${'★'.repeat(s.qual)}${s.notes ? '<br>'+s.notes : ''}</div>`
).join('');
}

function toggleTimer() {
if(tInt) { clearInterval(tInt); tInt = null; document.getElementById('timerBtn').textContent = '▶ Start'; }
else {
tSec = 0; document.getElementById('timerBtn').textContent = '⏸ Stop';
tInt = setInterval(() => {
tSec++;
document.getElementById('timerDisp').textContent =
new Date(tSec * 1000).toISOString().substr(11, 8);
}, 1000);
}
}

function playS(type) {
if(!aCtx) aCtx = new (window.AudioContext || window.webkitAudioContext)();
const osc = aCtx.createOscillator(), gain = aCtx.createGain();
osc.connect(gain); gain.connect(aCtx.destination);
const types = {white:'sawtooth', rain:'sawtooth', ocean:'sine', forest:'triangle'};
const freqs = {white:150, rain:200, ocean:60, forest:250};
osc.type = types[type] || 'sawtooth';
osc.frequency.value = freqs[type] || 150;
gain.gain.value = 0.08;
osc.start();
document.querySelectorAll('.sound-btn').forEach(b => b.classList.remove('on'));
event.currentTarget.classList.add('on');
const stop = parseInt(document.getElementById('autoStop').value);
if(stop > 0) setTimeout(() => osc.stop(), stop * 60000);
}

update();
</script>
</body>
</html>
