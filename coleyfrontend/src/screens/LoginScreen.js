import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { Alert, Button, Form } from "react-bootstrap";

function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  //const [isLogged, setIsLogged] = useState("")
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
          const isLogged = response.data.success
          const authUser = response.data.user[0]
          navigate('/select_role', {state: { isLogged, authUser }});
        } else {
          setError(response.data.error);
        }
      })
      .catch((error) => {
        setError(error.message);
      });
  };


  return (
    <div className="login-form">
      <div >
        <h1 className="m-5" >coley</h1> 
      </div>

      <h3 >login</h3>

      <Form  className="p-2" onSubmit={handleSubmit}>
        <div className="p-2" >
          <Form.Label htmlFor="username">Username: </Form.Label>
          <Form.Control
            type="text"
            id="username"
            value={username}
            onChange={(event) => setUsername(event.target.value)}
            required
          />
        </div>
        <div className="p-2">
          <Form.Label htmlFor="password">Password: </Form.Label>
          <Form.Control
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        <Button className="m-5" type="submit">Login</Button>
        {error && <Alert variant='danger'>{error}</Alert>}
      </Form>

    </div>
  );
}

export default Login;