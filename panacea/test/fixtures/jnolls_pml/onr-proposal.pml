/*
Process for submitting proposals to ONR.
*/

process proposal_submit {

  action submit_proposal {
    /*requires { "proposal" }*/
    script {
 "<p>Submit proposal contents.\
<p>BAA to which this proposal responds: \
<input name='baa' type='string' size=16 value='baa-12-96'>\
<br>Proposal title: <input name='title' type='string' size=50 \
value='Engineering a Procurement Process Architecture'>\
<br>Submitting Institution: <input name='institution' type='string' size=25 \
value='University of Southern California'>\
<br>Principle Invesigator: <input name='PI' type='string' size=20 \
value='Walt Scacchi'>\
Email: <input name='PIemail' type='string' size=20 \
value='scacchi@gilligan.usc.edu'>\
<br>Contact: <input name='contact' type='string' size=20 \
value='John Noll'>\
Email: <input name='contactEmail' type='string' size=12 \
value='jnoll@usc.edu'>\
<br>Proposal contents file: <INPUT NAME='file' TYPE='file'>\
"
    }
  }

  action submit_budget {
    script {
 "<p>Submit budget.\
<br>Proposal title: <input name='title' type='string' size=50 \
value='Engineering a Procurement Process Architecture'>\
<br>Budget file: <INPUT NAME='file' TYPE='file'>\
<br>Email address of contact: <input name='user_id' type='string' value='jnoll@usc.edu'>\
"
    }
  }

  action submit_certs {
    script {
"<p>Submit electronically signed certifications..\
<br>File containing signed certifications: <INPUT NAME='file' TYPE='file'>\
<p>User ID of signature: <input name='user_id' type='string' value='jnoll@usc.edu'>"
    }
  }
}
