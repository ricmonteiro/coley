import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useEffect } from 'react'
import { Button, Row, Col, Container } from 'react-bootstrap'



function MainDashboard() {
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged;
  const authUser = location.state && location.state.authUser;
  const navigate = useNavigate();

  useEffect(() => {
    console.log(authUser)
    if(!isLogged){
      navigate('/')}});

  const handleLogout = () => { 
    axios.post('/logout/', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }})
    .then((response) => {
      if (response.data.success) {
        navigate('/');
      } else {
        navigate('/');;
      }
    })
    
  }

  const handleCreateNewUser = () => {
    const isLogged = true
    navigate('/new_user', { state: { isLogged, selectedRole } });
  
    }

  const handleRegisterNewSample = () => {
      const isLogged = true
      navigate('/new_sample', { state: { isLogged, selectedRole, authUser } });
    
      }
      
  /*const handleRegisterNewCut = () => {
        const isLogged = true
        navigate('/new_cut', { state: { isLogged, selectedRole, authUser } });
      
        }*/

  const handleRegisterNewPatient = () => {
      const isLogged = true
      navigate('/new_patient', { state: { isLogged, selectedRole } });
      
        }

  const handleRegisterNewAnalysis = () => {
      const isLogged = true
      navigate('/new_analysis', { state: { isLogged, selectedRole, authUser } })

  }

  const handleSamplesAndCuts = () => {
    const isLogged = true
    navigate('/samples_and_cuts', { state: { isLogged, selectedRole, authUser } })

}

const handleGetResults = () => {
  const isLogged = true
  navigate('/get_results', {state : {isLogged, selectedRole, authUser}})

}

  return (
    <Container className='dash'>

      <h1>Dashboard</h1>
      {<h6>{authUser["0"]["first_name"]} {authUser["0"]["last_name"]}</h6>}
      {<h6><b>{selectedRole}</b></h6>}
      <Row>
      
      <Col>
      <div className='dash'>
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewPatient}>New patient</Button>}   
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>New sample</Button>}
      {/*selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewCut}>New cut</Button>*/}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewAnalysis}>New analysis</Button>}
      {/*selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>Upload result</Button>*/}
      {selectedRole === 'Admin' && <h5>Admin functions <p><Button className='admin-button m-2' onClick={handleCreateNewUser}>Create new user</Button></p></h5>}
      </div>
      </Col>
      <Col>

      <Row>
      <Button className='button m-2' onClick={handleSamplesAndCuts}>Samples and cuts</Button>
      </Row>

      <Row>
      <Button className='button m-2' onClick={handleGetResults}>Results</Button>
      </Row>
      </Col>
      <Col>

      
      </Col>
      </Row>
      <Button className='role-selection-buttons button m-2' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</Button>
    </Container>
  );
};

export default MainDashboard;