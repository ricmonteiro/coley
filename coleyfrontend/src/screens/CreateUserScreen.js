import React, { useState } from "react";
import axios from "axios";
import { useNavigate, useLocation } from "react-router-dom";
import { useEffect } from "react"

function CreateUser() {
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const location = useLocation();
  const isLogged = location.state && location.state.isLogged;

  useEffect(() => {
    if(!isLogged){
      navigate('/')}});
 
  return (
    <div>
      <h1>create new user</h1> 

      <h3>form here</h3>


    </div>
  );
}

export default CreateUser;