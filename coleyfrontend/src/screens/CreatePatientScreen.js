import React from 'react'
import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import axios from "axios";
import { useEffect } from "react"
import { Form, Button, Alert } from 'react-bootstrap'


function CreatePatient() {
    const navigate = useNavigate();
    const location = useLocation();
    const selectedRole = location.state && location.state.selectedRole;
    const isLogged = location.state && location.state.isLogged
    const authUser = location.state && location.state.authUser

    const [name, setName] = useState('');
    const [dob, setDob] = useState('');
    const [gender, setGender] = useState('')
    const [successMessage, setSuccessMessage] = useState('')
    const [submitError, setSubmitError] = useState('')
    const options = [
        { value: "female", label: "Female" },
        { value: "male", label: "Male" },
      ];
    
    useEffect(() => {
      if(!isLogged){
        navigate('/')}});
    

    const handleSubmit = (event) => {
      event.preventDefault();

      var formData = {
        name: name,
        dob: dob,
        gender: gender
      };
      
      axios.post('/new_patient/', formData, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
        .then(response => {
          setSuccessMessage(response.data.message)
        })
        .catch(error => {
          error.message = 'Please fill all the fields.'
          setSubmitError(error.message)
        });
    };
  
    const handleCancel = (event) => {
      console.log(isLogged)
      navigate(-1)
    }

    const handleChange = (event) => {
        setGender(event.target.value);
        console.log(gender)
      };

    return (
      <Form onSubmit={handleSubmit}>
        <h2>Insert patient details</h2>
        <Form.Label>
          Name:
          <Form.Control
            type="text"
            value={name}
            onChange={e => setName(e.target.value)}
          />
        </Form.Label>
        <Form.Label>
          Date of birth:
          <Form.Control
            type="date"
            value={dob}
            placeholder="dd-mm-yyyy"
            onChange={e => setDob(e.target.value)}
          />

        </Form.Label>
        

         <Form.Label>Gender:
          <Form.Select
        value={gender}
        onChange={handleChange}
        placeholder='Select gender'>
        <option value="" disabled selected>Select gender</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
        </Form.Select>
        </Form.Label>
        {(successMessage && <Alert variant='success'>{successMessage}</Alert>) || (submitError && <Alert variant='danger'>{submitError}</Alert>)}
        <Button  className='button m-2' type="submit">Create patient</Button>
        <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
      </Form>
    );
}

export default CreatePatient