import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

function Login() {
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
          console.log(response.data)
          //console.log("Logged in successfully");
          //console.log(response.data)
          navigate('/select_role');
        } else {
          setError(response.data.error);
        }
      })
      .catch((error) => {
        console.log(error);
      });
  };


  return (
    <div className="login-form">
      <h1>coley</h1> 

      <h3>login</h3>

      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="username">Username: </label>
          <input
            type="text"
            id="username"
            value={username}
            onChange={(event) => setUsername(event.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="password">Password: </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit">Login</button>
        {error && <p>{error}</p>}

      </form>
    </div>
  );
}

export default Login;