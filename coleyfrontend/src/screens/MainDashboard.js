import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useEffect } from 'react'
import { Button } from 'react-bootstrap'



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
  const handleRegisterNewCut = () => {
        const isLogged = true
        navigate('/new_cut', { state: { isLogged, selectedRole, authUser } });
      
        }

  const handleRegisterNewPatient = () => {
      const isLogged = true
      navigate('/new_patient', { state: { isLogged, selectedRole } });
      
        }

  return (
    <div className='dash'>
      <h1>Dashboard</h1>
      {<p>Role: {selectedRole}</p>}


      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewPatient}>New patient</Button>}   
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>New sample</Button>}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewCut}>New cut</Button>}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>New analysis</Button>}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>Upload result</Button>}
      {selectedRole === 'Admin' && <Button className='button m-2' onClick={handleCreateNewUser}>Create new user</Button>}
      <Button className='role-selection-buttons button m-2' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</Button>


    </div>
  );
};

export default MainDashboard;