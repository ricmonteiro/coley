import React, { useState } from "react";
import axios from "axios";
import { useNavigate, useLocation } from "react-router-dom";
import { useEffect } from "react"

function CreateUser() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const [firstname, setFirstName] = useState('');
  const [lastname, setLastName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirm, setPasswordConfirm] = useState('');
  const [roles, setRoles] = useState({
    admin: false,
    supervisor: false,
    technician: false,
    student: false,
  });

  const handleRoleChange = (event) => {
    const { name, checked } = event.target;
    setRoles(prevState => ({
      ...prevState,
      [name]: checked,
    }));
    console.log(roles)
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
    console.log(email)
    console.log(roles)
    

    axios.post('http://localhost:8000/api/create_user/', formData, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(response => {
        console.log(response.data);
      })
      .catch(error => {
        console.error('There was a problem submitting the form: ', error);
      });
  };

  const handleCancel = (event) => {
    navigate('/dashboard', {state : {isLogged, selectedRole}})
  }

  const passwordMatch = password === passwordConfirm;

  return (
    <form className='login-form' onSubmit={handleSubmit}>
      <h2>Insert user details</h2>
      <label>
        First name:
        <input
          type="text"
          value={firstname}
          onChange={e => setFirstName(e.target.value)}
        />
      </label>
      <label>
        Last name:
        <input
          type="text"
          value={lastname}
          onChange={e => setLastName(e.target.value)}
        />
      </label>
      <label>
        Username:
        <input
          type="text"
          value={username}
          onChange={e => setUsername(e.target.value)}
        />
      </label>
      <br />
      <label>
        Email:
        <input
          type="email"
          value={email}
          onChange={e => setEmail(e.target.value)}
        />
      </label>
      <br />
      <label>
        Password:
        <input
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
        />
      </label>
      <br />
      <label>
        Confirm Password:
        <input
          type="password"
          value={passwordConfirm}
          onChange={e => setPasswordConfirm(e.target.value)}
        />
      </label>
      {!passwordMatch && <div>Passwords do not match</div>}
      <br />
      <label>
       <h3>Roles: </h3>
        <br />
        <label>Admin
          <input
            type="checkbox"
            name="admin"
            checked={roles.admin}
            onChange={handleRoleChange}
          />
          
        </label>
        <br />
        <label>Supervisor
          <input
            type="checkbox"
            name="supervisor"
            checked={roles.supervisor}
            onChange={handleRoleChange}
          />
          
        </label>
        <br />
        <label>Technician
          <input
            type="checkbox"
            name="technician"
            checked={roles.technician}
            onChange={handleRoleChange}
          />
          
        </label>
        <br />
        <label>Student
          <input
            type="checkbox"
            name="student"
            checked={roles.student}
            onChange={handleRoleChange}
          />
          
        </label>
      </label>
      <br />
      <button type="submit">Register</button>
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleCancel}>Cancel</button>
    </form>
  );
}

export default CreateUser;