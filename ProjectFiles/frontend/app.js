const form = document.getElementById('synthForm');
const textInput = document.getElementById('text');
const voiceSelect = document.getElementById('voice');
const status = document.getElementById('status');
const player = document.getElementById('player');
const submitBtn = document.getElementById('submitBtn');
const downloadBtn = document.getElementById('downloadBtn');

let latestAudioUrl = null;

form.addEventListener('submit', async (e)=>{
  e.preventDefault();
  const text = textInput.value.trim();
  const voice = voiceSelect.value || 'Joanna';
  if(!text){ alert('Please type some text'); return; }

  status.textContent = 'Requesting synthesis…';
  submitBtn.disabled = true;

  try{
    const res = await fetch(`${window.API_BASE}/synthesize`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({text, voice})
    });
    const data = await res.json();
    if(!res.ok) throw new Error(data.error || 'Synthesis failed');

    // Lambda returns { public_url, presigned_url }
    latestAudioUrl = data.presigned_url || data.public_url;
    if(!latestAudioUrl) throw new Error('No audio URL returned');

    // Update audio player
    player.src = latestAudioUrl;
    player.play().catch(()=>{ /* autoplay may be blocked */ });

    // Update download button
    downloadBtn.style.display = 'inline-block';
    downloadBtn.onclick = () => {
      const a = document.createElement('a');
      a.href = latestAudioUrl;
      a.download = 'speech.mp3';
      a.click();
    };

    status.textContent = 'Done — play below';
  }catch(err){
    console.error(err);
    status.textContent = 'Error: ' + (err.message || 'Request failed');
    alert('Error: ' + (err.message || 'Request failed'));
  }finally{
    submitBtn.disabled = false;
  }
});
