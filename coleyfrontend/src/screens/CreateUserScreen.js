import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

function CreateUser() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = (event) => {
    event.preventDefault();
    axios
      .post('/login/', {
        username: username,
        password: password,
      }, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }})
      .then((response) => {
        if (response.data.success) {
          localStorage.setItem('token', response.data.token);
          navigate('/select_role');
        } else {
          setError(response.data.error);
        }
      })
      .catch((error) => {
        setError(error.message);
      });
  };


  return (
    <div>
      <h1>create new user</h1> 

      <h3>form here</h3>


    </div>
  );
}

export default CreateUser;