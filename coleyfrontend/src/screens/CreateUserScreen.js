import React, { useState } from "react";
import axios from "axios";
import { useNavigate, useLocation } from "react-router-dom";
import { useEffect } from "react"
import Alert from 'react-bootstrap/Alert';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import { Row, Col } from "react-bootstrap";


function CreateUser() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged;
  const authUser = location.state && location.state.authUser
  const [firstname, setFirstName] = useState('');
  const [lastname, setLastName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirm, setPasswordConfirm] = useState('');
  const [successMessage, setSuccessMessage] = useState('')
  const [roles, setRoles] = useState({
    admin: false,
    supervisor: false,
    technician: false,
    student: false,
  });
  
  useEffect(() => {
    if(!isLogged){
      navigate('/')}});

  const handleRoleChange = (event) => {
    const { name, checked } = event.target;
    setRoles(prevState => ({
      ...prevState,
      [name]: checked,
    }));
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    const formData = {
      username: username,
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      password_confirm: passwordConfirm,
      roles: roles,
    };    

    axios.post('http://localhost:8000/api/create_user/', formData, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(response => {
        setSuccessMessage(response.data.message)
        console.log(successMessage)

      })
      .catch(error => {
        console.error('There was a problem submitting the form: ', error);
      });
  };

  const handleCancel = (event) => {
    navigate(-1)
  }

  const passwordMatch = password === passwordConfirm;

  return (
    <Form onSubmit={handleSubmit}>
      <h2>Insert user details</h2>

      <Row className="mb-3">
      <Form.Group as={Col} className="m-1">
      <Form.Label column sm={4}>First name:</Form.Label >        
        <Form.Control
          type="text"
          value={firstname}
          onChange={e => setFirstName(e.target.value)}
        />    
        </Form.Group>

     <Form.Group as={Col} className="m-1">
      <Form.Label column sm={4}>Last name:</Form.Label>
        <Form.Control
          type="text"
          value={lastname}
          onChange={e => setLastName(e.target.value)}
        />
      </Form.Group>
      </Row>

      <Form.Group className="mb-3">
      <Form.Label>Username:</Form.Label>
        <Form.Control
          placeholder="Unique username, i.e. first_name.last_name"
          type="text"
          value={username}
          onChange={e => setUsername(e.target.value)}
        /> 
      </Form.Group>

      <Form.Group className="mb-1">

      <Form.Label>Email:</Form.Label>
        <Form.Control
        placeholder='Email'
          type="email"
          value={email}
          onChange={e => setEmail(e.target.value)}
        /> 
      </Form.Group >

      <Form.Label column>
        Password:
        <Form.Control
        placeholder='Write password'
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
        />
      </Form.Label>
      <Form.Label column>
        Confirm Password:
        <Form.Control
        placeholder='Confirm password'
          type="password"
          value={passwordConfirm}
          onChange={e => setPasswordConfirm(e.target.value)}
        />
      </Form.Label>
      {!passwordMatch && <div>Passwords do not match</div>}
       <h3 as={Row}>Roles: </h3>
        <Form.Group as={Row} className="mb-1 form">
          <Col>
        <Row>
          <Form.Check
            label='Admin'
            type="checkbox"
            name="admin"
            checked={roles.admin}
            onChange={handleRoleChange}
          />
        </Row>
        <Row>
        
          <Form.Check
            label='Supervisor'
            type="checkbox"
            name="supervisor"
            checked={roles.supervisor}
            onChange={handleRoleChange}
          />
        </Row>
        <Row>
          <Form.Check
            label='Technician'
            type="checkbox"
            name="technician"
            checked={roles.technician}
            onChange={handleRoleChange}
          />       
        </Row>
        <Row>
          <Form.Check
            label='Student'
            type="checkbox"
            name="student"
            checked={roles.student}
            onChange={handleRoleChange}
          />
      </Row>
      </Col>
      </Form.Group>
      {successMessage && <Alert variant='success'>{successMessage}</Alert>}
      <Button className='button m-2' type="submit">Create user</Button>
      <Button className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
      
    </Form>
  );
}

export default CreateUser;