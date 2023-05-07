import React from 'react'
import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { Form, Button, Row, Col} from 'react-bootstrap'
import axios from 'axios'


function CreateSample() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const [loading, setLoading] = useState('')
  const [error, setError] = useState('')
  const [patientList, setPatientList] = useState('')

  useEffect(() => {
    if(isLogged){
    setLoading(true)
    axios.get("/patient_list/")
    .then((response) => {
      setPatientList(response.data.data);
      setLoading(false)}
    )
    .catch((error) => {
      setError("An error occurred while retrieving the patients");
      console.error(error);
    });
  }else{navigate('/')}}, [navigate, isLogged, selectedRole]);
  
  const handleSubmit = (event) => {
    event.preventDefault();
    }

    const handleCancel = (event) => {
      navigate('/dashboard', {state : {isLogged, selectedRole}})
    }

    
      return (
        <Form>
          {loading}
          <p>{patientList}</p>
          {error && <p>{error}</p>}
          <Button className='button m-2' disabled={!selectedRole} onClick={handleSubmit}>Patient list</Button>
          <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
        </Form>
      );
}

export default CreateSample