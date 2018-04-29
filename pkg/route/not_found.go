package route

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// NotFound handle not found routes
func NotFound(c *gin.Context) {
	url := c.Request.URL.String()
	method := c.Request.Method

	c.JSON(http.StatusNotFound, gin.H{
		"url":    url,
		"method": method,
	})
}
